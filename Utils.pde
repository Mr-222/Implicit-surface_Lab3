void setSpheresColors(PVector coord) {
  float totalWeight = 0.0;
  PVector col = new PVector(0.0, 0.0, 0.0);
  for (int i = 0; i < 10; ++i) {
    PVector currCoord = coord.copy();
    currCoord = translate(currCoord, spheres_positions[i]);
    currCoord = scale(currCoord, new PVector(0.7, 0.7, 0.7));
    
    float weight = blobby(a_sphere.getValue(currCoord.x, currCoord.y, currCoord.z));
    col.add(PVector.mult(spheres_colors[i], weight));
    totalWeight += weight;
  }
  col.div(totalWeight);
  
  fill(col.x, col.y, col.z);
}

void setVertNormal(Vertex p1) {
  float h = 0.05;
  float dx = (implicit_func.getValue(p1.pos.x + h, p1.pos.y, p1.pos.z) - implicit_func.getValue(p1.pos.x - h, p1.pos.y, p1.pos.z)) / (2 * h);
  float dy = (implicit_func.getValue(p1.pos.x, p1.pos.y + h, p1.pos.z) - implicit_func.getValue(p1.pos.x, p1.pos.y - h, p1.pos.z)) / (2 * h);
  float dz = (implicit_func.getValue(p1.pos.x, p1.pos.y, p1.pos.z + h) - implicit_func.getValue(p1.pos.x, p1.pos.y, p1.pos.z - h)) / (2 * h);
  
  PVector n = new PVector(dx, dy, dz).normalize();
  normal(n.x, n.y, n.z);
}

PVector mult(PVector a, PVector b) {
  return new PVector(a.x * b.x, a.y * b.y, a.z * b.z);
}

PVector scale(PVector coord, PVector scaling) {
  PVector scale_new = new PVector(1.0 / scaling.x, 1.0 / scaling.y, 1.0 / scaling.z);
  return mult(coord, scale_new);
}

PVector translate(PVector coord, PVector translate) {
  PVector translate_new = translate.copy();
  translate_new.y = -translate_new.y;
  return PVector.sub(coord, translate_new);
}

PVector rotateZ(PVector coord, float theta) {
  Vector4f new_coord = new Vector4f(coord.x, coord.y, coord.z, 1.0);
  Matrix4x4f mat = Transformation3D.rotateZ(theta);
  new_coord = mat.mult(new_coord);
  
  return new PVector(new_coord.x, new_coord.y, new_coord.z);
}

PVector rotateX(PVector coord, float theta) {
  Vector4f new_coord = new Vector4f(coord.x, coord.y, coord.z, 1.0);
  Matrix4x4f mat = Transformation3D.rotateX(theta);
  new_coord = mat.mult(new_coord);
  
  return new PVector(new_coord.x, new_coord.y, new_coord.z);
}

PVector rotateY(PVector coord, float theta) {
  Vector4f new_coord = new Vector4f(coord.x, coord.y, coord.z, 1.0);
  Matrix4x4f mat = Transformation3D.rotateY(-theta);
  new_coord = mat.mult(new_coord);
  
  return new PVector(new_coord.x, new_coord.y, new_coord.z);
}

PVector twist(PVector coord, float frequency) {
  Matrix4x4f twist = Transformation3D.twist(coord.x, frequency);
  PMatrix3D mat = new PMatrix3D(
    twist.get(0, 0), twist.get(0, 1), twist.get(0, 2), twist.get(0, 3),
    twist.get(1, 0), twist.get(1, 1), twist.get(1, 2), twist.get(1, 3),
    twist.get(2, 0), twist.get(2, 1), twist.get(2, 2), twist.get(2, 3),
    twist.get(3, 0), twist.get(3, 1), twist.get(3, 2), twist.get(3, 3)
  );
  //mat.invert();
  
  PVector new_coord = coord.copy();
  mat.mult(new_coord, new_coord);
  
  return new PVector(new_coord.x, new_coord.y, new_coord.z);
}

PVector taper(PVector coord, float xMin, float xMax, float k1, float k2) {
  float x = coord.x;
  float y = coord.y;
  float z = coord.z;
  
  float t = 0;
  if (x < xMin)
    t = 0;
  else if (x > xMax)
    t = 1;
  else
    t = (x - xMin) / (xMax - xMin);
    
  float k = (1 - t) * k1 + t * k2;
  
  return new PVector(x, y / k, z / k);
}

ImplicitInterface boolean_intersection(ImplicitInterface a, ImplicitInterface b) {
  return (x, y, z) -> max(a.getValue(x, y, z), b.getValue(x, y, z));
}

ImplicitInterface boolean_subtraction(ImplicitInterface a, ImplicitInterface b) {
  return (x, y, z) -> max(a.getValue(x, y, z), 1.5 - b.getValue(x, y, z));
}
