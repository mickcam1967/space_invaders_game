# COSC101-A3 - Group 15 Submission
Asteroids submission for Group 15, comprising of:
 - Michael Campbell (mcampb58@my.une.edu.au)
 - Brodie Hicks (bhicks8@my.une.edu.au)
 - Jesse Fitzgerald (fitzg32@myune.edu.au)

## Startup Instructions
To launch the game, you will require Processing v3.3.7 (or newer) and will need to have the 'sound' library installed.

The sound library can be installed by:

 - Opening the a3_group15/a3_group15.pde file in Processing 
 - Opening the Sketch menu and selecting Import Library -> Add Library
 - Searching for 'sound'
 - Clicking 'install'

To launch the game:

 - Open a3_group15/a3_group15.pde in Processing (v3.3.7 or newer).
 - Click the 'Play' button to start.
 - Depending on the operating system, you may need to click inside the new window to start playing.

## Game Mechanics
The objective is to destroy as many asteroids as possible.
Game levels consist of 20 asteroids (configurable in Configuration.pde). 
Every time you complete a level the game will progressively speed up to increase the difficulty.
Colliding with an asteroid will destroy your ship and force you to restart in the centre of the screen, until your lives reach 0.
  
Statistics are shown in the top left of the screen and include:

 - Score: The number of asteroids destroyed.
 - Lives: The number of lives remaining. Every time you collide with an asteroid this decreases. At zero it's game over.
 - Level: The current level, based on the number of destroyed asteroids.
 - Speed: The current speed multiplier.
 - Time: The amount of time you have been alive.

## Controls
 - Ship movement is performed via the UP, DOWN, LEFT, RIGHT arrow keys.
 - SPACE to shoot the ship's lasers.
 - Hold SHIFT to engage an afterburner to speed up the ship.
 - Press TAB to toggle bounding box and velocity display for all objects.

## Advanced Techniques
As the laser velocity is based on the ships velocity, several techniques can be used to:

 - Slow lasers down by moving backwards and firing. You can effectively create a minefield to trap incoming asteroids this way.
 - Speed lasers up by engaging the afterburner and firing. This may help accuracy when hitting far-away asteroids.

## Tools Used
The following tools were used to develop the program:

- Processing v3.3.7 - development and launching the program
- Audacity - Used by Jesse to author the sound files.
- Slack (cosc101.slack.com) - channel name #group-15-t1-2018; main communication method between group members.
- Skype - regular phone conferences across the group.
- Trello (link to private board available on request) - Planning, assignment and organisation of tasks across the team.
- GitHub - Source control/versioning for the program.
- CodeShare - Collaborative editing of files during video conferencing to discuss and implement new features.
- OBS Studio - Video component of the assignment. 

## Assets Used
 - 2D Sprites for the ship and asteroids authored by MillionthVector (2017). 
   Retrieved from https://millionthvector.blogspot.com.au/p/free-sprites.html. 
   Licensed by MillionthVector under CC-BY-4.0
 - Sound files authored by Jesse using Audacity as mentioned above.
 
## Contribution Summary
All members of the team were involved in planning/design discussions however focus areas for each of the team members was:

 - Michael: Overview video, ship controls/movement and the scoring system. Assisted with collision detection and testing.
 - Jesse: Ship weapons (lasers), authoring and implementing sound files. Assisted with ship movement.
 - Brodie: Asteroid implementation, collision detection and inertia for ship controls. Refactored codebase into the class system.

## Further References
 - git_log.txt Contains a commit history for the git repository if of interest.
 - As the GitHub repository and Trello board are private, access could not be granted to them automatically.
   However access can be provisioned on request, if required.