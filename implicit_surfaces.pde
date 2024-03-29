// Create polygonalized implicit surfaces.

// for object rotation by mouse
int mouseX_old = 0;
int mouseY_old = 0;
PMatrix3D rot_mat;

// camera parameters
float camera_default = 6.0;
float camera_distance = camera_default;

boolean edge_flag = false;      // draw the polygon edges?
boolean normal_flag = true;   // use smooth normals during shading?

// iso-surface threshold
float threshold = 1.0;  

int timer;  // used to time parts of the code

// For drawing 10 spheres
boolean drawing_ten_spheres = false;
PVector spheres_positions[] = new PVector[10];
PVector spheres_colors[] = new PVector[10];
long seed = 0;

// For morphing
float t = 0;

// For drawing tree
boolean drawing_tree = false;

void setup()
{
  size (750, 750, OPENGL);
  
  // set up the rotation matrix
  rot_mat = (PMatrix3D) getMatrix();
  rot_mat.reset();
  
  // specify our implicit function is that of a sphere, then do isosurface extraction
  set_implicit (a_sphere);
  set_threshold (1.0);
  isosurface();
}

void draw()
{
  background (100, 100, 180);    // clear the screen

  perspective (PI*0.2, 1.0, 0.01, 1000.0);
  camera (0, 0, camera_distance, 0, 0, 0, 0, 1, 0);   // place the camera in the scene

  // create two directional light sources
  directionalLight (100, 100, 100, -0.7, 0.7, -1);
  directionalLight (182, 182, 182, 0, 0, -1);
  
  pushMatrix();

  // decide if we are going to draw the polygon edges
  if (edge_flag)
    stroke (0);  // black edges
  else
    noStroke();  // no edges

  fill (250, 250, 250);          // set the polygon color to white
  ambient (200, 200, 200);
  specular (0, 0, 0);            // turn off specular highlights
  shininess (1.0);
  
  applyMatrix (rot_mat);   // rotate the object using the global rotation matrix

  // draw the polygons from the implicit surface
  draw_surface();
  
  popMatrix();
}

// remember where the user clicked
void mousePressed()
{
  mouseX_old = mouseX;
  mouseY_old = mouseY;
}

// change the object rotation matrix while the mouse is being dragged
void mouseDragged()
{
  if (!mousePressed)
    return;

  float dx = mouseX - mouseX_old;
  float dy = mouseY - mouseY_old;
  dy *= -1;

  float len = sqrt (dx*dx + dy*dy);
  if (len == 0)
    len = 1;

  dx /= len;
  dy /= len;
  PMatrix3D rmat = (PMatrix3D) getMatrix();
  rmat.reset();
  rmat.rotate (len * 0.005, dy, dx, 0);
  rot_mat.preApply (rmat);

  mouseX_old = mouseX;
  mouseY_old = mouseY;
}

// handle keystrokes
void keyPressed()
{
  if (key == CODED) {
    if (keyCode == UP) {
      camera_distance *= 0.9;
    }
    else if (keyCode == DOWN) {
      camera_distance /= 0.9;
    }
    return;
  }
  
  if (key == 'e') {
    edge_flag = !edge_flag;
  }
  if (key == 'n') {
    normal_flag = !normal_flag;
  }
  if (key == 'r') {  // reset camera view and rotation
    rot_mat.reset();
    camera_distance = camera_default;
  }
  if (key == 'w') {  // write triangles to a file
    String filename = "implicit_mesh.cli";
    write_triangles (filename);
    println ("wrote triangles to file: " + filename);
  }
  if (key == ',') {  // decrease the grid resolution
    if (gsize > 10) {
      gsize -= 10;
      isosurface();
    }
  }
  if (key == '.') {  // increase the grid resolution
    gsize += 10;
    isosurface();
  }
  if (key == '1') {
    drawing_ten_spheres = false;
    drawing_tree = false;
    set_threshold (1.0);
    set_implicit (a_sphere);
    isosurface();
  }
  if (key == '!') {
    drawing_ten_spheres = false;
    drawing_tree = false;
    set_threshold(1.0);
    set_implicit (flying_saucer);
    isosurface();
  }
  if (key == '2') {
    drawing_ten_spheres = false;
    drawing_tree = false;
    set_threshold(.6);
    set_implicit(blending_4_spheres);
    isosurface();
  }
  if (key == '@') {
    drawing_ten_spheres = true;
    drawing_tree = false;
    seed = System.nanoTime();
    set_threshold(.5);
    set_implicit(blending_10_spheres);
    isosurface();
  }
  if (key == '3') {
    drawing_ten_spheres = false;
    drawing_tree = false;
    set_threshold(.5);
    set_implicit(unit_line_segment);
    isosurface();
  }
  if (key == '#') {
    drawing_ten_spheres = false;
    drawing_tree = false;
    set_threshold(.8);
    set_implicit(blobby_square);
    isosurface();
  }
  if (key == '4') {
    drawing_ten_spheres = false;
    drawing_tree = false;
    set_threshold(-0.5);
    set_implicit(torus);
    isosurface();
  }
  if (key == '$') {
    gsize += 60;
    drawing_ten_spheres = false;
    drawing_tree = false;
    set_threshold(-1);
    set_implicit(chain);
    isosurface();
    gsize -= 60;
  }
  if (key == '5') {
    drawing_ten_spheres = false;
    drawing_tree = false;
    set_threshold(0.5);
    set_implicit(long_line_segment);
    isosurface();
  }
  if (key == '%') {
    gsize += 60;
    drawing_ten_spheres = false;
    drawing_tree = false;
    set_threshold(0.5);
    set_implicit(twisted_line);
    isosurface();
    gsize -= 60;
  }
  if (key == '6') {
    drawing_ten_spheres = false;
    drawing_tree = false;
    set_threshold(0.5);
    set_implicit(tapered_line);
    isosurface();
  }
  if (key == '^') {
    gsize += 60;
    drawing_ten_spheres = false;
    drawing_tree = false;
    set_threshold(0.5);
    set_implicit(twisted_tapered_line);
    isosurface();
    gsize -= 60;
  }
  
  if (key == 'z') {
    threshold -= 0.1;
    isosurface();
  }
  if (key == 'x') {
    threshold += 0.1;
    isosurface();
  }
  if (key == '7') {
    drawing_ten_spheres = false;
    drawing_tree = false;
    set_threshold (1.0);
    set_implicit (saucer);
    isosurface();
  }
  if (key == '&') {
    drawing_ten_spheres = false;
    drawing_tree = false;
    set_threshold (1.0);
    set_implicit (hole);
    isosurface();
  }
  if (key == '8') {
    drawing_ten_spheres = false;
    drawing_tree = false;
    if (t >= 0.1)
      t -= 0.1;
    set_threshold (0.5);
    set_implicit (morph);
    isosurface();
  }
  if (key == '9') {
    drawing_ten_spheres = false;
    drawing_tree = false;
    if (t <= 0.9)
      t += 0.1;
    set_threshold (0.5);
    set_implicit (morph);
    isosurface();
  }
  if (key == '0') {
    gsize += 60;
    drawing_ten_spheres = false;
    drawing_tree = true;
    set_threshold (0.9);
    set_implicit (tree);
    isosurface();
    gsize -= 60;
  }
}

void reset_timer()
{
  timer = millis();
}

void print_timer()
{
  int new_timer = millis();
  int diff = new_timer - timer;
  float seconds = diff / 1000.0;
  println ("timer = " + seconds);
}
