public class TAG_File {

  private int index;
  private ArrayList<anchor_received> connected = new ArrayList<anchor_received>();
  private double x_est = 0;
  private double y_est = 0;
  TAG_File(int x)
  {
    this.index= x;
  }

  public void addition(int anchor_index, int RSSI)
  {
    anchor_received ref = new anchor_received(anchor_index, RSSI);
    int i=0;
    int flag=0;
    for (i=0; i<connected.size(); i++)
    {
      anchor_received ref2 = connected.get(i);
      if (ref2.indexRequest() == anchor_index)
      {
        connected.set(i, ref);
        flag=1;
        break;
      }
    }
    if (flag == 0)
      connected.add(ref);

    sorting();
    
    if(connected.size()>=3)
    {
      boolean flag2 = true;
      for (i=0; i<connected.size(); i++)
      {
         double temp = (connected.get(i)).Request_Distance();
         if(temp == 0)
         {
          flag2 = false;
          break;
         }
      }
      if(flag2)
        calculate_point();
    }
  }
  
 public void calculate_point()
 {
   color Tag_color = color(255,204,0);
   
  double x1 = (connected.get(0)).XCor; 
  double y1 = (connected.get(0)).YCor;
  double x2 = (connected.get(1)).XCor; 
  double y2 = (connected.get(1)).YCor;
  double x3 = (connected.get(2)).XCor;
  double y3 = (connected.get(2)).YCor;
  double r1 = (connected.get(0)).Request_Distance();
  double r2 = (connected.get(1)).Request_Distance();
  double r3 = (connected.get(2)).Request_Distance();
  println("R1="+r1+" R2="+r2+" R3="+r3);
  
  stroke(0);
  noFill();
  ellipse((float)x1/pixel_bred , (float)y1/pixel_leng , (float)r1/pixel_bred ,(float)r1/pixel_leng);
  noFill();
  ellipse((float)x2/pixel_bred , (float)y2/pixel_leng , (float)r2/pixel_bred ,(float)r2/pixel_leng);
  noFill();
  ellipse((float)x3/pixel_bred , (float)y3/pixel_leng , (float)r3/pixel_bred ,(float)r3/pixel_leng);
  
  y_est += (x2-x3)*(Math.pow((double)x2,2)-Math.pow((double)x1,2)) + (Math.pow((double)y2,2)-Math.pow((double)y1,2)) + (Math.pow(r1,2)-Math.pow(r2,2));
  y_est -= ((x1-x2)*((Math.pow((double)x3,2)-Math.pow((double)x2,2)) + (Math.pow((double)y3,2)-Math.pow((double)y2,2)) + (Math.pow(r2,2)-Math.pow(r3,2))));
  y_est /= (2*((y1-y2)*(x2-x3)-(y2-y3)*(x1-x2)));
  x_est += (y2-y3)*((Math.pow((double)y2,2)-Math.pow((double)y1,2)) + (Math.pow((double)x2,2)-Math.pow((double)x1,2)) + (Math.pow(r1,2)-Math.pow(r2,2)));
  x_est -= ((y1-y2)*((Math.pow((double)y3,2)-Math.pow((double)y2,2)) + (Math.pow((double)x3,2)-Math.pow((double)x2,2)) + (Math.pow(r2,2)-Math.pow(r3,2))));
  x_est /= (2*((x1-x2)*(y2-y3)-(x2-x3)*(y1-y2)));
  
  Tag_color = color(0,255,0);
  fill(Tag_color);
  ellipse((float)x_est/pixel_bred , (float)y_est/pixel_leng , 20 ,20);
  println("X estimate : " + x_est);
  println("Y estimate : " + y_est);
  println("*******************\n");

  y_est = 0;
  x_est = 0;
 }
  
  private void sorting()
  {
    for (int i=0; i<connected.size()-1; i++)
    {
      for (int j=0; j<connected.size()-i-1; j++)
      {
        if ((connected.get(j)).RSSIRequest() < (connected.get(j+1)).RSSIRequest())
        {
          anchor_received temp = connected.get(j);
          connected.set(j, connected.get(j+1));
          connected.set(j+1, temp);
        }
      }
    }
  }
  
  public void print()
  {  
    println("Index Tag: " + tags.get(index));
    for (int i=0; i<connected.size(); i++)
    {
      (connected.get(i)).print();
    }
  }

  public void Anchor_Connected()
  {
    println("Anchor_Connected :-" + connected.size());
  } 
}
