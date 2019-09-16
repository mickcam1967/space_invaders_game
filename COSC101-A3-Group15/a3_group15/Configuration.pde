/*
 * File: Configuration.pde
 * Authors: Michael Campbell, Jesse Fitsgerald, Brodie Hicks
 * Date: 21/05/2018
 * Desc: Contains configuration globals for the program.
 */
 
//Screen size
static PVector screenDimensions = new PVector(800, 800);

//Ship related configuration.
static PVector shipSize = new PVector(40, 56); //Size

//Initial position (default to centre screen).
static PVector shipResetPosition = new PVector(400, 400); 
static PVector shipResetVelocity = new PVector(0,0); //Initial velocity.
static PVector shipResetAcceleration = new PVector(0,0); //Initial acceleration
static float   shipResetRotation = 0; //Initial rotation in radians.
static float   shipResetRotationVelocity = 0; //Initial rotational velocity.
static float   shipResetRotationAcceleration = 0; //Rotational acceleration. 

//Asteroid related configuration.
static PVector asteroidSize = new PVector(42, 42); //Asteroid size.
static float maxAsteroidVelocity = 4; //Max velocity for new asteroids.
static float asteroidSizeVariance = 0.00; //Percentage size variance
static int screenAsteroidCount = 5; //Max number of asteroids on-screen
static int levelAsteroidCount = 20; //Asteroids per level.

//Weapon related configuration
static PVector laserSize = new PVector(10, 12);

//World related configuration.
static float initialSpeedMultiplier = 0.80; //Starting speed for the game.
static float levelSpeedMultiplierIncrease = 0.20; //Increment per level.

//Global flag to show bounding boxes - for debugging.
boolean showBoundingBoxes = false;
