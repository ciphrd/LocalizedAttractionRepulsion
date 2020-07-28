class Particle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float radius = 5;
  
  public Particle (float x, float y) {
    this.position = new PVector(x, y);
    this.velocity = new PVector(0, 0);
    this.acceleration = new PVector(0, 0);
  }
  
  // adds the acceleration to the velocity and then the velocity to the 
  // position, apply friction
  public void update () {
    this.velocity.add(this.acceleration);
    this.acceleration.mult(0);
    // velocity gets clamped if over the threshold
    float mag = this.velocity.mag();
    if (mag > maxVelocity) {
      this.velocity = this.velocity.normalize().mult(maxVelocity); 
    }
    this.position.add(this.velocity);
    this.velocity.mult(frictionDecay);
  }
  
  public void draw () {
    // draw vectors 
    // drawVector(acceleration.copy().mult(60), position.x, position.y, new int[]{0, 255, 0, 255});
  
    noFill();
    stroke(255);
    strokeWeight(2);
    
    pushMatrix();
    translate(position.x, position.y);
    
    circle(0, 0, radius*2);
    
    popMatrix();
  }
}
