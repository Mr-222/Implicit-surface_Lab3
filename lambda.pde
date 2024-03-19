// Lambda expressions for implicit functions
//
// See the "a_sphere" lambda expression for an example of defining an implicit function

import java.lang.FunctionalInterface;
import java.util.Random;

// this is a functional interface that will let us define an implicit function
@FunctionalInterface
interface ImplicitInterface {

  // abstract method that takes (x, y, z) and returns a float
  float getValue(float x, float y, float z);
}

// Implicit function for a sphere at the origin.
//
// This may look like a function definition, but it is a lambda expression that we are
// storing in the variable "a_sphere" using =. Note the -> and the semi-colon after the last }

ImplicitInterface a_sphere = (x, y, z) -> {
  float d = sqrt (x*x + y*y + z*z);
  return (d);
};

ImplicitInterface flying_saucer = (x, y, z) -> {
  y = y * 3;
  return a_sphere.getValue(x, y, z);
};

float blobby(float d) {
  if (d <= 1) {
    float alpha = 1.0 - d * d;
    return alpha * alpha * alpha;
  }
  
  return 0;
}

ImplicitInterface blending_sphere_closer = (x, y, z) -> {
  float d1 = blobby(a_sphere.getValue(x - .5, y + 1, z));
  float d2 = blobby(a_sphere.getValue(x + .5, y + 1, z));
  
  return d1 + d2;
};

ImplicitInterface blending_sphere_farther = (x, y, z) -> {
  float d1 = blobby(a_sphere.getValue(x - .55, y - 1, z));
  float d2 = blobby(a_sphere.getValue(x + .55, y - 1, z));
  
  return d1 + d2;
};

ImplicitInterface blending_4_spheres = (x, y, z) -> {
  return blending_sphere_closer.getValue(x, y, z) + blending_sphere_farther.getValue(x, y, z);
};

ImplicitInterface blending_10_spheres = (x, y, z) -> {
  Random random = new Random(seed);
  float d = 0;
  PVector coord = new PVector(x, y, z);
  for (int i = 0; i < 10; ++i) {
    float transX = random.nextFloat(3) - 1.5;
    float transY = random.nextFloat(3) - 1.5;
    float transZ = random.nextFloat(1) - 1.0;
    spheres_positions[i] = new PVector(transX, transY, transZ);
    
    int r = random.nextInt(256);
    int g = random.nextInt(256);
    int b = random.nextInt(256);
    spheres_colors[i] = new PVector(r, g, b);
    
    PVector new_coord = coord.copy();
    new_coord = translate(new_coord, spheres_positions[i]);
    new_coord = scale(new_coord, new PVector(0.7, 0.7, 0.7));
    
    d += blobby(a_sphere.getValue(new_coord.x, new_coord.y, new_coord.z));
  }
  
  return d;
};


class LineSegmentGenerator {
  PVector p1;
  PVector p2;
  
  LineSegmentGenerator(PVector P1, PVector P2) {
    this.p1 = P1;
    this.p2 = P2;
  }
  
  ImplicitInterface generate() {
    return (x, y, z) -> {
        PVector q = new PVector(x, y, z);
  
        PVector D = PVector.sub(p2, p1);
        PVector V = PVector.sub(q, p1);
        
        float t = PVector.dot(D, V) / D.magSq();
        float d = 0;
        if (t < 0)
          d = PVector.sub(p1, q).mag();
        else if (t > 1)
          d = PVector.sub(q, p2).mag();
        else {
          PVector hitPoint = PVector.add(p1, PVector.mult(D, t));
          d = PVector.sub(q, hitPoint).mag();
        }
          
        return d;
    };
  }
}

ImplicitInterface unit_line_segment = (x, y, z) -> {
  var gen = new LineSegmentGenerator(new PVector(-0.6, 0, 0), new PVector(0.6, 0, 0));
  return gen.generate().getValue(x, y, z);
};

ImplicitInterface blobby_square = (x, y, z) -> {
  float d = 0;
  
  // Up
  var gen1 = new LineSegmentGenerator(new PVector(-0.6, 0.8, 0), new PVector(0.6, 0.8, 0));
  d += blobby(gen1.generate().getValue(x, y, z));
  
  // Down
  var gen2 = new LineSegmentGenerator(new PVector(-0.6, -0.8, 0), new PVector(0.6, -0.8, 0));
  d += blobby(gen2.generate().getValue(x, y, z));
  
  // Left
  var gen3 = new LineSegmentGenerator(new PVector(-0.8, 0.6, 0), new PVector(-0.8, -0.6, 0));
  d += blobby(gen3.generate().getValue(x, y, z));
  
  // Up
  var gen4 = new LineSegmentGenerator(new PVector(0.8, 0.6, 0), new PVector(0.8, -0.6, 0));
  d += blobby(gen4.generate().getValue(x, y, z));
  
  return d;
};

ImplicitInterface torus = (x, y, z) -> {
  float R = 1.0;
  float r = 0.7;
  float alpha = x * x + y * y + z * z + R * R - r * r;
  float beta = x * x + y * y;
  return alpha * alpha - 4 * R * R * beta;
};

ImplicitInterface chain = (x, y, z) -> {
  PVector coord = new PVector(x, y, z);
  float d = 0;
  
  PVector mid = scale(coord, new PVector(0.4, 0.4, 0.4));
  d += blobby(torus.getValue(mid.x, mid.y, mid.z));
  
  PVector left = translate(coord, new PVector(-1, 0, 0));
  left = rotateX(left, (float)Math.toRadians(45));
  left = scale(left, new PVector(0.4, 0.4, 0.4));
  d += blobby(torus.getValue(left.x, left.y, left.z));
  
  PVector right = translate(coord, new PVector(1, 0, 0));
  right = rotateX(right, (float)Math.toRadians(-45));
  right = scale(right, new PVector(0.4, 0.4, 0.4));
  d += blobby(torus.getValue(right.x, right.y, right.z));
  
  return d;
};

ImplicitInterface long_line_segment = (x, y, z) -> {
  var gen = new LineSegmentGenerator(new PVector(-1.2, 0, 0), new PVector(1.2, 0, 0));
  
  PVector coord = new PVector(x, y, z);
  coord = translate(coord, new PVector(0, 0.5, 0));
  coord = scale(coord, new PVector(1, 0.8, 0.8));
  float d = gen.generate().getValue(coord.x, coord.y, coord.z);
  
  return d;
};

ImplicitInterface twisted_line = (x, y, z) -> {
  PVector coord = new PVector(x, y, z);
  coord = twist(coord, 6.0);
  
  return long_line_segment.getValue(coord.x, coord.y, coord.z);
};

ImplicitInterface tapered_line = (x, y, z) -> {
  PVector coord = new PVector(x, y, z);
  coord = taper(coord, -2.5, 2.5, 0.2, 1.2);
  coord = translate(coord, new PVector(0, -.5, 0));
  
  return long_line_segment.getValue(coord.x, coord.y, coord.z);
};


ImplicitInterface twisted_tapered_line = (x, y, z) -> {
  PVector coord = new PVector(x, y, z);
  coord = twist(coord, 6.0);
  coord = translate(coord, new PVector(0, -.5, 0));
  coord = taper(coord, -2.5, 2.5, 0.2, 1);
  
  return long_line_segment.getValue(coord.x, coord.y, coord.z);
};

class SphereGenerator {
  PVector center;
  
  SphereGenerator(PVector center) {
    this.center = center;
  }
  
  ImplicitInterface generate() {
    return (x, y, z) -> {
      return sqrt((x - center.x) * (x - center.x) + (y + center.y) * (y + center.y) + (z - center.z) * (z - center.z));
    };
  }
}

ImplicitInterface saucer = (x, y, z) -> {
  var gen1 = new SphereGenerator(new PVector(0, 0.5, 0));
  var gen2 = new SphereGenerator(new PVector(0, -0.5, 0));
  
  return boolean_intersection(gen1.generate(), gen2.generate()).getValue(x, y, z);
};

ImplicitInterface hole = (x, y, z) -> {
  var gen1 = new SphereGenerator(new PVector(0, 0, 0));
  var gen2 = new LineSegmentGenerator(new PVector(0, 0, 2), new PVector(0, 0, -2));
  
  PVector coord = new PVector(x, y, z);
  coord = rotateY(coord, (float)Math.toRadians(15));
  
  return boolean_subtraction(gen1.generate(), gen2.generate()).getValue(coord.x, coord.y, coord.z);
};

ImplicitInterface lock = (x, y, z) -> {
  var gen1 = new LineSegmentGenerator(new PVector(0, 0, 2), new PVector(0, 0, -2));
  var gen2 = new LineSegmentGenerator(new PVector(-2, 0, 0), new PVector(2, 0, 0));
  var gen3 = new LineSegmentGenerator(new PVector(0, 2, 0), new PVector(0, -2, 0));
  
  PVector coord = new PVector(x, y, z);
  coord = rotateY(coord, (float)Math.toRadians(-25));
  coord = rotateX(coord, (float)Math.toRadians(25));
  coord = scale(coord, new PVector(0.6, 0.6, 0.6));
  
  float d = 0;
  d += blobby(gen1.generate().getValue(coord.x, coord.y, coord.z));
  d += blobby(gen2.generate().getValue(coord.x, coord.y, coord.z));
  d += blobby(gen3.generate().getValue(coord.x, coord.y, coord.z));
  
  return d;
};

ImplicitInterface morph = (x, y, z) -> {
  return blobby(a_sphere.getValue(x / 3, y / 3, z / 3)) * (1 - t) + lock.getValue(x, y, z) * t;
};

ImplicitInterface tree = (x, y, z) -> {
  var gen = new TrunkGenerator();
  return gen.generate().getValue(x, y, z);
};
