static public class Vector4f {
  public float x, y, z, w;
  
  public Vector4f(float x, float y,float z, float w) {
    this.x = x;
    this.y = y;
    this.z = z;
    this.w = w;
  }
  
  public Vector4f(PVector vec3, float w) {
    this.x = vec3.x;
    this.y = vec3.y;
    this.z = vec3.z;
    this.w = w;
  }
}
