import processing.sound.*;
import processing.video.*;
import java.util.TimerTask;
import java.util.Timer;
import java.util.Date;

ParticleSystem ps;

PFont typo;

SoundFile fantasySong;
Movie intro;
SoundFile AudioFortune;
SoundFile AudioAmour;
SoundFile AudioCarriere;

 float biscuitPositionX;
 float biscuitPositionY;
 float biscuitWidth;
 float biscuitHeight;
 float biscuitScaleUp;
 float biscuitScaleDown;
 float biscuitMinX;
 float biscuitMinY;
 float biscuitMaxX;
 float biscuitMaxY;
 
float timelineDuration = 10.0f;

float timeScale = 1.0f;
float timeScaleMin = 0.25f;
float timeScaleMax = 100.0f;
float timeScaleDelta = 0.25f;

float offsetHorizontal = 64.0f;

float timelinePlayhead;
float timelinePlayheadPosition;

float timelinePositionStartX;
float timelinePositionStartY;
float timelinePositionEndX;
float timelinePositionEndY;
float timelinePositionDelta;
float timelineMarkerHalfSize;

float timeNow;
float timeLast;
float timeElapsed;

String Titre = "titre.png";
String BiscuitFortuneGauche = "biscuitfortune01.png";
String BiscuitFortuneDroite = "biscuitfortune02.png";
String BiscuitAmourGauche = "biscuitamour01.png";
String BiscuitAmourDroite = "biscuitamour02.png";

JSONObject json;

String videoFile;
String musicFile;
String audioFile01;
String audioFile02;
String audioFile03;

boolean playVideo = true;
boolean isOverBiscuit;
boolean isBiscuitPressed;
boolean showBiscuit = true; 
boolean isTimelineActive = true;

int savedTime;
int totalTime = 6000;
PImage imgTitre;
PImage imgBiscuitFortuneGauche;
PImage imgBiscuitFortuneDroite;
PImage imgBiscuitAmourGauche;
PImage imgBiscuitAmourDroite;


String[] words = {"bonne chance", "célèbre la vie", "allume une chandelle",  "masse ton 3e oeil", "quelqu'un pense à toi", "le succès s'en vient", "oui mais non","sors dehors", "pourquoi pas?", "danse", "l'alignement des astres est en ta faveur", "écris à ton.ta crush", "on t'envoie des ondes positives", "ça pourrait aller mieux", "mange plus de légumes", "inspire, expire" };
String currentWord = "";

void setup()
{ 
 
  readConfig();
   
  size(1080, 1080);
  frameRate(60);
  textAlign(CENTER,CENTER);
  textSize(36);
  
  typo = loadFont("STYuanti-SC-Regular-48.vlw");
  
  textFont(typo);
  
  timeNow = timeLast = timeElapsed = 0.0f;

  timelinePlayhead = 0.0f;

  timelinePositionStartX = offsetHorizontal;
  timelinePositionStartY = height - height/3 + 45 ;
  timelinePositionEndX = width - offsetHorizontal;
  timelinePositionEndY = timelinePositionStartY;
  timelinePositionDelta = timelinePositionEndX - timelinePositionStartX;
  timelineMarkerHalfSize = 32.0f;
  
  ps = new ParticleSystem(new PVector(width/2, 85));
  

  fantasySong = new SoundFile(this, musicFile);
  fantasySong.play();
  
  AudioFortune = new SoundFile(this, audioFile01);
  AudioAmour = new SoundFile(this, audioFile02);
  AudioCarriere = new SoundFile(this, audioFile03);

 imgTitre = loadImage(Titre);
 imgBiscuitFortuneGauche = loadImage(BiscuitFortuneGauche);
 imgBiscuitFortuneDroite = loadImage(BiscuitFortuneDroite);
 imgBiscuitAmourGauche = loadImage(BiscuitAmourGauche);
 imgBiscuitAmourDroite = loadImage(BiscuitAmourDroite);

 
 biscuitPositionX = width / 2.0f;
 biscuitPositionY = height / 2.0f;
 biscuitWidth = width * 0.5f;
 biscuitHeight = height * 0.3f;
 biscuitScaleUp = 1.05f;
 biscuitScaleDown = 0.95f;
 biscuitMinX = biscuitPositionX - (biscuitWidth / 2.0f);
 biscuitMinY = biscuitPositionY - (biscuitHeight / 2.0f);
 biscuitMaxX = biscuitPositionX + (biscuitWidth / 2.0f);
 biscuitMaxY = biscuitPositionY + (biscuitHeight / 2.0f);
 isOverBiscuit = false;
 isBiscuitPressed = false ; 
 
 imageMode(CORNER);

  loadVideo();
   
  savedTime = millis();
  

}

void draw()
{
  background(#f9dee8);
 
  ps.addParticle();
  ps.run();

  
  drawTitre();
  drawPapier();
  drawWord();
      

  timeNow = millis();
  timeElapsed = (timeNow - timeLast) / 1000.0f * timeScale;
  timeLast = timeNow;


  if (isTimelineActive)
  {  
    timelinePlayhead += timeElapsed;

    if (timelinePlayhead >= timelineDuration)
    {

     timelinePlayhead -= timelineDuration;
    }
  }


  timelinePlayheadPosition = timelinePlayhead / timelineDuration * timelinePositionDelta + timelinePositionStartX;
  float alpha = timelinePlayheadPosition/4;
  
 
  stroke(255);
  strokeWeight(10);
  line(timelinePositionStartX, timelinePositionStartY, timelinePositionEndX, timelinePositionEndY);

  
  stroke(255);
  strokeWeight(12);
  line(timelinePositionStartX, timelinePositionStartY - timelineMarkerHalfSize, timelinePositionStartX, timelinePositionStartY + timelineMarkerHalfSize);

  
  stroke(255);
  strokeWeight(12);
  line(timelinePositionEndX, timelinePositionEndY - timelineMarkerHalfSize, timelinePositionEndX, timelinePositionEndY + timelineMarkerHalfSize);

 
  stroke(255,128,172,alpha);
  strokeWeight(20);
  line(timelinePlayheadPosition, timelinePositionStartY - timelineMarkerHalfSize, timelinePlayheadPosition, timelinePositionStartY + timelineMarkerHalfSize);

  
  textSize(30);
  fill(#FF468A);
  text("Indice de chance", width/2, height - height/4 + 20);
  fill(255);
  text("Peu élevé" , 120, height - height/4+20);
  text("Très élevé ", 960, height - height/4+20);     
      
      
  if(showBiscuit && !isBiscuitPressed) {
    drawBiscuit02();
  }
  

  if (mouseX >= biscuitMinX && mouseX <= biscuitMaxX) {

    if (mouseY >= biscuitMinY && mouseY <= biscuitMaxY)
    {
      isOverBiscuit = true;
    }
    else
      isOverBiscuit = false;
  }
  else
    isOverBiscuit = false;


  if (isBiscuitPressed == true)
  {

   drawBiscuitOuvert();

  }
  else if (isOverBiscuit == true) 
  {

    drawBiscuit01();
    cursor(HAND); 
    
  }
  else 
  {
    cursor(CROSS);
  }


  int passedTime = millis() - savedTime;
  
  if (passedTime > totalTime) {
    savedTime = millis(); // Save the current time to restart the timer!
    playVideo = false;
  }
  
  if(playVideo) {
    image(intro, 0, 0); 
  }
  

if(keyPressed) {
  if (key == 'f' || key == 'F') {
      if (fantasySong.isPlaying()) {
        fantasySong.pause();
      } else {
        fantasySong.play();
      }
    }
   } 
}


void movieEvent(Movie intro) {
  intro.read();
}


void readConfig() {
  json = loadJSONObject("config.json");

  videoFile = json.getString("videoFile");
  musicFile = json.getString("musicFile");
  audioFile01 = json.getString("audioFile01");
  audioFile02 = json.getString("audioFile02");
  audioFile03 = json.getString("audioFile03");

  
}


void drawPapier() {
  fill(255);
  rectMode(CENTER);
  rect(width/2,950,800,120); 
}

void drawBiscuit01 () {
   image(imgBiscuitFortuneGauche, 275, 350);
   image(imgBiscuitFortuneDroite, 430,400);
}

void drawBiscuit02 () {
   image(imgBiscuitAmourGauche, 275, 350);
   image(imgBiscuitAmourDroite, 430,400);     
}

void drawBiscuitOuvert () {
   pushMatrix();
   translate(-100,0);
   image(imgBiscuitFortuneGauche, 275, 350);
   translate(200,0);
   image(imgBiscuitFortuneDroite, 430,400);
   popMatrix();
}


void drawWord () {
    fill(#E5AA07);
    text(currentWord, width/2, 950);
}
  
void drawTitre() {
  // chargement du fichier en mémoire
  pushMatrix();  
  rotate(PI/60);
  scale(0.8);
  image(imgTitre,180, height/9);
  filter(ERODE);
  popMatrix();
}


void loadVideo() {
  intro = new Movie(this, videoFile);
  intro.play();
  AudioAmour.play();
}



void mousePressed() {
  if (isOverBiscuit == true && (mouseButton == LEFT || mouseButton == RIGHT)) {
      isBiscuitPressed = true;
    
      int index = int(random(words.length));  
      currentWord = words[index];
    
      AudioCarriere.play();
      
      showOpenedBiscuit();
  }
}



void showOpenedBiscuit() {
    isBiscuitPressed = true;
    TimerTask task = new TimerTask() {
        public void run() {
         isBiscuitPressed = false; 
        }
    };
    
    Timer timer = new Timer("Timer");
    
    int delay = 2000;
    timer.schedule(task, delay);
}



void keyPressed()
{
  if (keyCode == UP)
    timeScale = constrain(timeScale + timeScaleDelta, timeScaleMin, timeScaleMax);
  if (keyCode == DOWN)
    timeScale = constrain(timeScale - timeScaleDelta, timeScaleMin, timeScaleMax);
  if (key == ENTER || key == RETURN)
  saveFrame("ma chance.jpg");
  
   if (keyCode == ' ')
    isTimelineActive = !isTimelineActive;
    
    if (keyCode == ' ')
    AudioFortune.play();   

}
 
