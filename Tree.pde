PVector Brown = new PVector(150, 75, 0);
PVector Green = new PVector(0, 200, 0);
PVector Light_Brown = new PVector(210, 180, 140);


class TwigGenerator {
  TwigGenerator() {}
  
  ImplicitInterface generate() {
    return (x, y, z) -> {
      float d = 0;
      PVector coord = new PVector(x, y, z);
      
      PVector coord1 = coord.copy();
      coord1 = rotateZ(coord1, (float)Math.toRadians(-90));
      coord1 = translate(coord1, new PVector(-0.6, 0, 0));
      coord1 = scale(coord1, new PVector(0.4, 0.4, 0.4));
      d += blobby(tapered_line.getValue(coord1.x, coord1.y, coord1.z));
      
      PVector coord2 = coord.copy();
      coord2 = rotateZ(coord2, (float)Math.toRadians(-90));
      coord2 = translate(coord2, new PVector(-1.5, 0, 0));
      coord2 = scale(coord2, new PVector(0.6, 0.6, 0.6));
      d += blobby(a_sphere.getValue(coord2.x, coord2.y, coord2.z));
      
      return d + 0.2;
    };
  }
  
  public Pair<Float, PVector> getUnweightedColor(float x, float y, float z) {
      float totalWeight = 0;
      float weight = 0;
      PVector col = new PVector(0, 0, 0);
      PVector coord = new PVector(x, y, z);
      
      PVector coord1 = coord.copy();
      coord1 = rotateZ(coord1, (float)Math.toRadians(-90));
      coord1 = translate(coord1, new PVector(-0.6, 0, 0));
      coord1 = scale(coord1, new PVector(0.4, 0.4, 0.4));
      weight = blobby(tapered_line.getValue(coord1.x, coord1.y, coord1.z));
      totalWeight += weight;
      col.add(PVector.mult(Brown, weight));
      
      PVector coord2 = coord.copy();
      coord2 = rotateZ(coord2, (float)Math.toRadians(-90));
      coord2 = translate(coord2, new PVector(-1.5, 0, 0));
      coord2 = scale(coord2, new PVector(0.6, 0.6, 0.6));
      weight = blobby(a_sphere.getValue(coord2.x, coord2.y, coord2.z));
      totalWeight += weight;
      col.add(PVector.mult(Green, weight));
      
      return new Pair<>(totalWeight, col);
  }
}

class TrunkGenerator {
  TrunkGenerator() {}
  
  public ImplicitInterface generate() {
    return (x, y, z) -> {
      float d = 0;
      PVector coord = new PVector(x, y, z);
      coord = translate(coord, new PVector(0, -0.1, 0));
      
      var gen1 = new LineSegmentGenerator(new PVector(0, 2, 0), new PVector(0, -2, 0));
      PVector coord1 = coord.copy();
      coord1 = scale(coord1, new PVector(0.5, 0.5, 0.5));
      d += blobby(gen1.generate().getValue(coord1.x, coord1.y, coord1.z));
      
      PVector coord2 = coord.copy();
      coord2 = translate(coord2, new PVector(0.2, -1.0, 0));
      coord2 = scale(coord2, new PVector(0.5, 0.5, 0.5));
      d += blobby(a_sphere.getValue(coord2.x, coord2.y, coord2.z));
      
      PVector coord3 = coord.copy();
      coord3 = translate(coord3, new PVector(-0.2, -1.0, 0));
      coord3 = scale(coord3, new PVector(0.5, 0.5, 0.5));
      d += blobby(a_sphere.getValue(coord3.x, coord3.y, coord3.z));
      
      PVector coord4 = coord.copy();
      coord4 = translate(coord4, new PVector(0, -1.0, 0.2));
      coord4 = scale(coord4, new PVector(0.5, 0.5, 0.5));
      d += blobby(a_sphere.getValue(coord4.x, coord4.y, coord4.z));
      
      PVector coord5 = coord.copy();
      coord5 = translate(coord5, new PVector(0, -1.0, -0.2));
      coord5 = scale(coord5, new PVector(0.5, 0.5, 0.5));
      d += blobby(a_sphere.getValue(coord5.x, coord5.y, coord5.z));
      
      PVector coord10 = coord.copy();
      coord10 = translate(coord10, new PVector(0, -1.2, 0));
      coord10 = scale(coord10, new PVector(1.5, 1.5, 1.5));
      d += blobby(flying_saucer.getValue(coord10.x, coord10.y, coord10.z));
      
      // twig
      var twig = new TwigGenerator().generate();
      
      PVector coord6 = coord.copy();
      coord6 = translate(coord6, new PVector(-0.3, -0.1, 0));
      coord6 = scale(coord6, new PVector(0.6, 0.6, 0.6));
      coord6 = rotateZ(coord6, (float)Math.toRadians(45));
      d += twig.getValue(coord6.x, coord6.y, coord6.z);
      
      PVector coord7 = coord.copy();
      coord7 = translate(coord7, new PVector(0.3, 0.3, 0));
      coord7 = scale(coord7, new PVector(0.7, 0.7, 0.7));
      coord7 = rotateZ(coord7, (float)Math.toRadians(-45));
      d += twig.getValue(coord7.x, coord7.y, coord7.z);
      
      PVector coord8 = coord.copy();
      coord8 = translate(coord8, new PVector(-0.3, 0.75, 0));
      coord8 = scale(coord8, new PVector(0.4, 0.4, 0.4));
      coord8 = rotateZ(coord8, (float)Math.toRadians(55));
      d += twig.getValue(coord8.x, coord8.y, coord8.z);
      
      PVector coord9 = coord.copy();
      coord9 = translate(coord9, new PVector(0.3, -0.4, 0));
      coord9 = scale(coord9, new PVector(0.5, 0.5, 0.5));
      coord9 = rotateZ(coord9, (float)Math.toRadians(-45));
      d += twig.getValue(coord9.x, coord9.y, coord9.z);
      
      return d;
    };
  }
  
      
    public PVector getColor(float x, float y, float z) {
      float totalWeight = 0;
      float weight = 0;
      PVector col = new PVector(0, 0, 0);
      

      PVector coord = new PVector(x, y, z);
      coord = translate(coord, new PVector(0, -0.1, 0));
      
      var gen1 = new LineSegmentGenerator(new PVector(0, 2, 0), new PVector(0, -2, 0));
      PVector coord1 = coord.copy();
      coord1 = scale(coord1, new PVector(0.5, 0.5, 0.5));
      weight = blobby(gen1.generate().getValue(coord1.x, coord1.y, coord1.z));
      col.add(PVector.mult(Brown, weight));
      totalWeight += weight;
      
      PVector coord2 = coord.copy();
      coord2 = translate(coord2, new PVector(0.2, -1.0, 0));
      coord2 = scale(coord2, new PVector(0.5, 0.5, 0.5));
      weight = blobby(a_sphere.getValue(coord2.x, coord2.y, coord2.z));
      col.add(PVector.mult(Brown, weight));
      totalWeight += weight;
      
      PVector coord3 = coord.copy();
      coord3 = translate(coord3, new PVector(-0.2, -1.0, 0));
      coord3 = scale(coord3, new PVector(0.5, 0.5, 0.5));
      weight = blobby(a_sphere.getValue(coord3.x, coord3.y, coord3.z));
      col.add(PVector.mult(Brown, weight));
      totalWeight += weight;
      
      PVector coord4 = coord.copy();
      coord4 = translate(coord4, new PVector(0, -1.0, 0.2));
      coord4 = scale(coord4, new PVector(0.5, 0.5, 0.5));
      weight = blobby(a_sphere.getValue(coord4.x, coord4.y, coord4.z));
      col.add(PVector.mult(Brown, weight));
      totalWeight += weight;
      
      PVector coord5 = coord.copy();
      coord5 = translate(coord5, new PVector(0, -1.0, -0.2));
      coord5 = scale(coord5, new PVector(0.5, 0.5, 0.5));
      weight = blobby(a_sphere.getValue(coord5.x, coord5.y, coord5.z));
      col.add(PVector.mult(Brown, weight));
      totalWeight += weight;
      
      PVector coord10 = coord.copy();
      coord10 = translate(coord10, new PVector(0, -1.2, 0));
      coord10 = scale(coord10, new PVector(1.5, 1.5, 1.5));
      weight = blobby(flying_saucer.getValue(coord10.x, coord10.y, coord10.z));
      col.add(PVector.mult(Light_Brown, weight));
      totalWeight += weight;
      
      // twig
      var twigGen = new TwigGenerator();
      Pair<Float, PVector> unweightedCol;
      
      PVector coord6 = coord.copy();
      coord6 = translate(coord6, new PVector(-0.3, -0.1, 0));
      coord6 = scale(coord6, new PVector(0.6, 0.6, 0.6));
      coord6 = rotateZ(coord6, (float)Math.toRadians(45));
      unweightedCol = twigGen.getUnweightedColor(coord6.x, coord6.y, coord6.z);
      col.add(unweightedCol.get_second());
      totalWeight += unweightedCol.get_first();
      
      PVector coord7 = coord.copy();
      coord7 = translate(coord7, new PVector(0.3, 0.3, 0));
      coord7 = scale(coord7, new PVector(0.7, 0.7, 0.7));
      coord7 = rotateZ(coord7, (float)Math.toRadians(-45));
      unweightedCol = twigGen.getUnweightedColor(coord7.x, coord7.y, coord7.z);
      col.add(unweightedCol.get_second());
      totalWeight += unweightedCol.get_first();
      
      PVector coord8 = coord.copy();
      coord8 = translate(coord8, new PVector(-0.3, 0.75, 0));
      coord8 = scale(coord8, new PVector(0.4, 0.4, 0.4));
      coord8 = rotateZ(coord8, (float)Math.toRadians(55));
      unweightedCol = twigGen.getUnweightedColor(coord8.x, coord8.y, coord8.z);
      col.add(unweightedCol.get_second());
      totalWeight += unweightedCol.get_first();
      
      PVector coord9 = coord.copy();
      coord9 = translate(coord9, new PVector(0.3, -0.4, 0));
      coord9 = scale(coord9, new PVector(0.5, 0.5, 0.5));
      coord9 = rotateZ(coord9, (float)Math.toRadians(-45));
      unweightedCol = twigGen.getUnweightedColor(coord9.x, coord9.y, coord9.z);
      col.add(unweightedCol.get_second());
      totalWeight += unweightedCol.get_first();
      
      col.div(totalWeight);
      
      return col;
    }
}
