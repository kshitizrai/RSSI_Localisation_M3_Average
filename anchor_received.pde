public class anchor_received
{
 private int index;
 private int RSSI=0;
 private double distance = 0;
 private double n ;
 private double A;
 public double XCor;
 public double YCor;
 public int value_received = 0;
 
 anchor_received(int index , int RSSI)
 {
  this.index = index;
  this.RSSI += RSSI;
  this.value_received++;
  if(value_received>=5)
  {
   this.RSSI = this.RSSI/value_received; 
   Anchor anchor_ref=anchors.get(index);
   this.n = (double)anchor_ref.Request_n();
   this.A = (double)anchor_ref.Request_A();
   this.XCor = anchor_ref.Anchor_XCor();
   this.YCor = anchor_ref.Anchor_YCor();
   this.distance = ((double)this.RSSI-A)/(10*n);
   this.distance = (Math.pow((10),this.distance))*100;
   this.value_received = 0; 
  }
 }
 
 public double Request_Distance()
 {
  return(this.distance); 
 }
  
 public int indexRequest()
 {
  return(index); 
 }
 
 public int RSSIRequest()
 {
   return(RSSI);   
 }
 
 public void print()
 {
   println("Index Anchor: " + (anchors.get(index)).requestAnchorMAC());
   println("RSSI: " + RSSI);
   println("N: " + n);
 }
 
}
