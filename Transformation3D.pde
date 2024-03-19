public static class Transformation3D
{
  static Matrix4x4f translate(float tx, float ty, float tz) {
    var mat = new Matrix4x4f();
    
    mat.set(0, 0, 1f);
    mat.set(1, 1, 1f);
    mat.set(2, 2, 1f);
    mat.set(3, 3, 1f);
    
    mat.set(0, 3, tx);
    mat.set(1, 3, ty);
    mat.set(2, 3, tz);
    
    return mat;
  }
  
  static Matrix4x4f scale(float sx, float sy, float sz) {
    var mat = new Matrix4x4f();
    
    mat.set(0, 0, sx);
    mat.set(1, 1, sy);
    mat.set(2, 2, sz);
    mat.set(3, 3, 1f);
    
    return mat;
  }
  
  static Matrix4x4f rotateX(float theta) {
    var mat = new Matrix4x4f();
    
    mat.set(0, 0, 1f);
    mat.set(1, 1, cos(theta));
    mat.set(1, 2, -sin(theta));
    mat.set(2, 1, sin(theta));
    mat.set(2, 2, cos(theta));
    mat.set(3, 3, 1f);
    
    return mat;
  }
  
  static Matrix4x4f rotateY(float theta) {
    var mat = new Matrix4x4f();
    
    mat.set(0, 0, cos(theta));
    mat.set(0, 2, sin(theta));
    mat.set(1, 1, 1f);
    mat.set(2, 0, -sin(theta));
    mat.set(2, 2, cos(theta));
    mat.set(3, 3, 1f);
    
    return mat;
  }
  
  static Matrix4x4f rotateZ(float theta) {
    var mat = new Matrix4x4f();
    
    mat.set(0, 0, cos(theta));
    mat.set(0, 1, -sin(theta));
    mat.set(1, 0, sin(theta));
    mat.set(1, 1, cos(theta));
    mat.set(2, 2, 1f);
    mat.set(3, 3, 1f);
    
    return mat;
  }
  
  static Matrix4x4f rotate(PVector axis, float theta) {
    var mat = new Matrix4x4f();
        
    // Normalize the axis vector
    axis.normalize();
    float ux = axis.x;
    float uy = axis.y;
    float uz = axis.z;

    float c = cos(theta);
    float s = sin(theta);
    float oneMinusC = 1.0f - c;

    // Row 1
    mat.set(0, 0, c + ux * ux * oneMinusC);
    mat.set(0, 1, ux * uy * oneMinusC - uz * s);
    mat.set(0, 2, ux * uz * oneMinusC + uy * s);
    mat.set(0, 3, 0);

    // Row 2
    mat.set(1, 0, uy * ux * oneMinusC + uz * s);
    mat.set(1, 1, c + uy * uy * oneMinusC);
    mat.set(1, 2, uy * uz * oneMinusC - ux * s);
    mat.set(1, 3, 0);

    // Row 3
    mat.set(2, 0, uz * ux * oneMinusC - uy * s);
    mat.set(2, 1, uz * uy * oneMinusC + ux * s);
    mat.set(2, 2, c + uz * uz * oneMinusC);
    mat.set(2, 3, 0);

    // Row 4
    mat.set(3, 0, 0);
    mat.set(3, 1, 0);
    mat.set(3, 2, 0);
    mat.set(3, 3, 1);

    return mat;
  }
  
  static Matrix4x4f identity() {
    var mat = new Matrix4x4f();
    
    mat.set(0, 0, 1f);
    mat.set(1, 1, 1f);
    mat.set(2, 2, 1f);
    mat.set(3, 3, 1f);
    
    return mat;
  }
  
  static Matrix4x4f twist(float theta, float frequency) {
    var mat = new Matrix4x4f();
    
    mat.set(0, 0, 1f);
    mat.set(1, 1, cos(theta * frequency));
    mat.set(1, 2, -sin(theta * frequency));
    mat.set(2, 1, sin(theta * frequency));
    mat.set(2, 2, cos(theta * frequency));
    mat.set(3, 3, 1f);
    
    return mat;
  }
}
