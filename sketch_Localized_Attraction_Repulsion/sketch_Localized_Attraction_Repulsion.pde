// @author ciphrd https://ciphered.xyz
// @license MIT
//
// Localized Attraction-Repulsion
//
// Particles are subject to attraction / repulsion, but the attraction / repulsion only works
// within a specific range, allowing for more diverse behaviors.
//
// This system is described in the following article:
// https://ciphered.xyz/2020/07/28/localized-attraction-repulsion:-generative-matter/
//


// the maximum velocity a particle can reach (it gets clamped if over this value)
float maxVelocity = 1.0;
float frictionDecay = 0.7;

// attraction strength (Sa in the article)
float attrStrength = 32.0;
// repulsion strength (Sr in the article)
float repStrength = 30.0;
// attraction strength towards the center
float centerAttraction = 0.0001;

// attraction/repulsion range
float attrRange = 13;
float repRange = 20;

// collision strength and response strength
float colStrength = 0.5;
float colResponse = 0.3;


PVector center = new PVector(256, 256);

Particle[] particles = new Particle[800];

void setup () {
  size(512, 512); 
  
  for (int i = 0; i < particles.length; i++) {
    particles[i] = new Particle(
      random(200) + 156,
      random(200) + 156
    );
  }
}

void draw () {
  background(0);
  
  
  for (int i = 0; i < particles.length; i++) {
    Particle p1 = particles[i];
    PVector col = new PVector(0, 0);
    
    for (int j = 0; j < particles.length; j++) {
      if (i != j) {
        Particle p2 = particles[j];
        
        PVector D = p2.position.copy().sub(p1.position);
        float r = D.mag();
        D = D.normalize();
        
        if (r > 0.5) { // prevent weird behavior from particles overlaping
          if (r <= attrRange) {
            PVector Fa = D.copy().mult(attrStrength).div(r*r);
            p1.acceleration.add(Fa);
          }
          
          if (r <= repRange) {
            PVector Fr = D.copy().mult(-repStrength).div(r*r);
            p1.acceleration.add(Fr);
          }
          
          if (r < p1.radius + p2.radius) {
            PVector mv = D.copy().mult(-((p1.radius + p2.radius) - r));
            p1.velocity.add(mv.copy().mult(colStrength));
            p2.velocity.add(mv.mult(-colResponse));
          }
        }
      }
    }
    
    // we add attraction to the center
    p1.acceleration.add(p1.position.copy().sub(center).mult(-centerAttraction));
    
    p1.update();
    p1.draw();
  }
}
