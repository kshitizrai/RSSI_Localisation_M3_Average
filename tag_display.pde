public class tag_display {
  double x_cor;
  double y_cor;
  float pix_len,pix_bred;
  tag_display (double x,double y,float len,float bred){
    this.x_cor=x;
    this.y_cor=y;
    this.pix_len=len;
    this.pix_bred=bred;
  }
  //display the position of the tag
  public void display(int R,int G, int B){
    color Tag_color = color(255,204,0);
    Tag_color = color(R,G,B);
    fill(Tag_color);
    ellipse((float)x_cor/pix_bred , (float)y_cor/pix_bred , 20 ,20);
  }
}
