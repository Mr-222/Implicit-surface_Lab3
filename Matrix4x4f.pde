static public class Matrix4x4f
{
  private float[][] data;
  
  public Matrix4x4f() {
    data = new float[4][4];
  }
  
  public Matrix4x4f(Matrix4x4f other) {
    data = new float[4][4];
    for (int i=0; i<4; ++i)
      for (int j=0; j<4; ++j)
        data[i][j] = other.get(i, j);
  }
  
  public Matrix4x4f copy() {
    return new Matrix4x4f(this);
  }
  
  public void set(int row, int col, float value) {
    assert(row >= 0 && row <= 3);
    assert(col >= 0 && col <= 3);
    data[row][col] = value;
  }
  
  public float get(int row, int col) {
    assert(row >= 0 && row <= 3);
    assert(col >= 0 && col <= 3);
    return data[row][col];
  }
  
  public PMatrix3D convert_to_PMatrix3D() {
    return new PMatrix3D(data[0][0], data[0][1], data[0][2], data[0][3],
                         data[1][0], data[1][1], data[1][2], data[1][3],
                         data[2][0], data[2][1], data[2][2], data[2][3],
                         data[3][0], data[3][1], data[3][2], data[3][3]);
  }
  
  public Matrix4x4f mult(Matrix4x4f other) {
    Matrix4x4f result = new Matrix4x4f();
    for (int i=0; i<4; ++i)
      for (int j=0; j<4; ++j)
        for (int k=0; k<4; ++k)
          result.data[i][j] += this.data[i][k] * other.data[k][j];
    
    return result;
  }
  
  public Vector4f mult(Vector4f vec) {
    float[] result = new float[4];
    for (int i=0; i<4; ++i)
      result[i] = data[i][0] * vec.x + data[i][1] * vec.y + data[i][2] * vec.z + data[i][3] * vec.w;
    return new Vector4f(result[0], result[1], result[2], result[3]);
  }
}
