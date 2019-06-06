public class Anchor  {
  private String Anchor_MAC;
  private float Anchor_X;
  private float Anchor_Y;
  private float n;
  private float A;
  private color Anchor_color = color(255,0,0);
   
 // Anchor (String Anchor_MAC,float n ,float Anchor_X,float Anchor_Y)
  Anchor(String Anchor_MAC, float Anchor_X, float Anchor_Y, float n, float A)
  {
   this.Anchor_MAC = Anchor_MAC;
   this.Anchor_X = (Anchor_X);
   this.Anchor_Y = (Anchor_Y);
   this.n = n;
   this.A = A;
   fill(this.Anchor_color);
   ellipse(this.Anchor_X/pixel_bred , this.Anchor_Y/pixel_leng , 50 ,50);
  }
 
  public float Request_n()
  {
   return(this.n);
  }
  
  public float Request_A()
  {
   return(this.A);
  }
  
  public String requestAnchorMAC()
  {
    return(this.Anchor_MAC);
  }
  
  public float Anchor_XCor()
  {
   return(this.Anchor_X); 
  }
  
  public float Anchor_YCor()
  {
   return(this.Anchor_Y); 
  } 

  public void print()
  {
   println("Anchor MAC: "+this.Anchor_MAC);
   println("X: "+this.Anchor_X," Y: ",Anchor_Y);
   println("N: "+this.n);
   println("A: "+this.A);
  }
}
