import processing.serial.*;
import java.util.Scanner;
import java.util.ArrayList;
import java.util.List;
import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.List;
import java.lang.Math;
import controlP5.*;

Serial port;
ControlP5 cp5;
Group g1;
int row_no;

String input;
String text;

TableRow row;
Table table;

float breadth = 1000;
float leng = 1000;
float pixel_bred = (breadth/500);
float pixel_leng = (leng/500);

ArrayList<Anchor> anchors = new ArrayList<Anchor>();
ArrayList<String> tags = new ArrayList<String>();
ArrayList<TAG_File> Tags_Data  = new ArrayList<TAG_File>();

String COM_PORT = "COM10";

byte[] header = new byte[50];
int byte_received = 0;
boolean error_status = true;
int crc = 0;
int payload_crc;


void setup()
{
  size(1000, 1050);
  background(255, 204, 0);
  port = new Serial(this, COM_PORT, 38400);
 
  table=loadTable("C:/Users/KEVIN/Documents/Processing/localization_gps/data/anchor2.csv","header");
  table.clearRows();
  println("row no init",table.getRowCount());

  cp5 = new ControlP5(this);
 
   g1 = cp5.addGroup("Anchor Data")
                .setBackgroundColor(color(0, 64))
                .setBackgroundHeight(1000).setPosition(0,10).setSize(200,1000)
                ;
  cp5.addTextfield("MAC Address ").setPosition(10, 10).setSize(140, 100).setAutoClear(false).setFont(createFont("Times New Roman",20)).moveTo(g1);
  cp5.addTextfield("X cordinate ").setPosition(10, 160).setSize(140, 100).setAutoClear(false).setFont(createFont("Times New Roman",20)).setInputFilter(ControlP5.FLOAT).moveTo(g1);
  cp5.addTextfield("Y cordinate ").setPosition(10, 310).setSize(140, 100).setAutoClear(false).setFont(createFont("Times New Roman",20)).setInputFilter(ControlP5.FLOAT).moveTo(g1);
  cp5.addTextfield("N value ").setPosition(10, 460).setSize(140, 100).setAutoClear(false).setFont(createFont("Times New Roman",20)).setInputFilter(ControlP5.FLOAT).moveTo(g1);
  cp5.addTextfield("A value ").setPosition(10, 610).setSize(140, 100).setAutoClear(false).setFont(createFont("Times New Roman",20)).setInputFilter(ControlP5.FLOAT).moveTo(g1);
  
  cp5.addBang("Submit").setPosition(30, 750).setSize(70,50 ).setFont(createFont("Arial",20)).moveTo(g1);
  cp5.addBang("Exit").setPosition(30, 850).setSize(70,50 ).setFont(createFont("Arial",20)).moveTo(g1);

  String File = "tag.csv";
  BufferedReader br = null;
  String line = "";
  String cvsSplitBy = ",";

  try {
    br = new BufferedReader(new FileReader(File));
    
    while (line != null) {
      String[] splited = line.split(cvsSplitBy);
      tags.add(splited[0]);
      line = br.readLine();
    }
  }
  catch (FileNotFoundException e) {
    e.printStackTrace();
  } 
  catch (IOException e) {
    e.printStackTrace();
  } 
  finally {
    if (br != null) {
      try {
        br.close();
      } 
      catch (IOException e) {
        e.printStackTrace();
      }
    }
  }
  

 for (int i=0; i<tags.size(); i++)
  {
    //   println(tags.get(i));
    TAG_File tag_data_ref = new TAG_File(i);
    Tags_Data.add(tag_data_ref);
  }

}

void draw()
{
 
  serial2Event(port);

}

void serial2Event(Serial port)
{

  if (port.available()>0)
  {
    byte nByte = (byte)port.read();

    header[byte_received] = nByte;
    byte_received += 1 ;
    // println(hex(nByte));
    // println("Received:"+ byte_received);
    if (byte_received == 2)
    {
      if (header[0]==0x00 && header[1]==0x06)
      {
        error_status = true;
        println("Success0");
      } else
      {
        byte_received = 0;
        port.clear();
        error_status = false;      
        println("Failure0");
      }
    }
/*
    if (byte_received <= 8 && error_status)
    {
      if (byte_received != 7)
        crc += header[byte_received-1];
      else
        crc += header[byte_received-1]<<8;
    }
    if (byte_received == 8 && error_status)
    {
      if (crc != -257)
      {
        byte_received = 0;
        port.clear();
        error_status = false;
        println("Failure");
      } else
      {
        println("Success");
      }
      crc = 0;
    }
  */  
    if (byte_received == 41)
    {

      byte_received = 0;  
      String TAG_address = (hex(header[27]) + ":" + hex(header[28]) + ":" + hex(header[29]));
      String Anchor_address = (hex(header[17]) + ":" + hex(header[18]) + ":" + hex(header[19]));
      int RSSI = int(header[34])-256;
      //      println("Anchor_initial:"+Anchor_address);
      int index_tag = tags.indexOf(TAG_address);
      int index_anchor = 0;
      for (index_anchor=0; index_anchor<anchors.size(); index_anchor++)
      {
        Anchor anchor_ref = anchors.get(index_anchor);
        if ((Anchor_address).equals(anchor_ref.requestAnchorMAC()))
        {
          println("Index:"+index_tag);
          if (index_tag != -1) 
            (Tags_Data.get(index_tag)).addition(index_anchor, RSSI);
          //        println("Matched With:"+anchor_ref.requestAnchorMAC());
          break;
        }
      }
      if(index_tag != -1)
        (Tags_Data.get(index_tag)).print();
    }
  }
}
void Submit() {
  row_no=1;
  println("submit",row_no);
   row =table.addRow();
  println("Row",table.getRowCount()); 
  String text=cp5.get(Textfield.class, "MAC Address ").getText();
 
  cp5.get(Textfield.class, "MAC Address ").setText("");
  println(text);
  row.setString("MAC Address", text);
  saveTable(table, "data/anchor2.csv");
  
  String text1=cp5.get(Textfield.class, "X cordinate ").getText();
   cp5.get(Textfield.class, "X cordinate ").setText("");
   println(text1);
  row.setString("X cordinate",text1);
  saveTable(table, "data/anchor2.csv");

 
  String text2=cp5.get(Textfield.class, "Y cordinate ").getText();
  cp5.get(Textfield.class, "Y cordinate ").setText("");
  println(text2);
  row.setString("Y cordinate",text2);
  saveTable(table, "data/anchor2.csv");
 
  String text3=cp5.get(Textfield.class, "N value ").getText();
  cp5.get(Textfield.class, "N value ").setText("");
  println(text3);
  row.setString("N value",text3);
  saveTable(table, "data/anchor2.csv");

 
  String text4=cp5.get(Textfield.class, "A value ").getText();
  cp5.get(Textfield.class, "A value ").setText("");
  println(text4);
  row.setString("A value",text4);
  saveTable(table, "data/anchor2.csv");
  
}
void Exit(){
  background(255, 204, 204);
  g1.remove();
  getAnchor();

}

public void getAnchor()
{
  
  background(255, 204, 204);
 
     String File_ = "C:/Users/KEVIN/Documents/Processing/localization_gps/data/anchor2.csv";
    
  BufferedReader br_ = null;
  String line_ = "";
  String cvsSplitBy_ = ",";
  
  try {
    br_ = new BufferedReader(new FileReader(File_));
   String tr= br_.readLine();
    
    
    println("First line",tr);
    int count=0;
    
  while ((line_ = br_.readLine()) != null) {
     
      count++;
      println("count",count);
     
      String[] splited = line_.split(cvsSplitBy_);
      println("the input",line_);
      Anchor anchor_ref = new Anchor(splited[0],float(splited[1]),float(splited[2]),float(splited[3]),float(splited[4]));
      //println("values",splited[1]);
      anchors.add(anchor_ref);
      
    }
  }
  catch (FileNotFoundException e) {
    e.printStackTrace();
  } 
  catch (IOException e) {
    e.printStackTrace();
  } 
  finally {
    if (br_ != null) {
      try {
        br_.close();
      }
      catch (IOException e) {
        e.printStackTrace();
      }
    }
  }
  println("size",anchors.size());
   for(int i=0 ; i<anchors.size(); i++)
 {
   println("this is i",i);
  Anchor anchor_ref = anchors.get(i);
  anchor_ref.print();
 }
 

}
