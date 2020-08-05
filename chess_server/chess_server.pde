import processing.net.*;
Server myserver;

final int pw = 1;
final int nw = 2;
final int bw = 3;
final int rw = 4;
final int qw = 5;
final int kw = 6;

final int pb = -1;
final int nb = -2;
final int bb = -3;
final int rb = -4;
final int qb = -5;
final int kb = -6;

final int empty = 0;
final int selected = 100;
//final int possiblemove = 101;
int piecechosen = 0;
int promotedpawn = 0;
int kingcount = 0;

int mode;
final int start= 10;
final int playing = 20;
final int pawnpromotion = 30;
final int gameover = 40;


int[][] board = { 
  {rw, nw, bw, kw, qw, bw, nw, rw}, 
  {pw, pw, pw, pw, pw, pw, pw, pw}, 
  {0, 0, 0, 0, 0, 0, 0, 0}, 
  {0, 0, 0, 0, 0, 0, 0, 0}, 
  {0, 0, 0, 0, 0, 0, 0, 0}, 
  {0, 0, 0, 0, 0, 0, 0, 0}, 
  {pb, pb, pb, pb, pb, pb, pb, pb}, 
  {rb, nb, bb, kb, qb, bb, nb, rb}, 
};

PImage pawnwhite;
PImage knightwhite;
PImage bishopwhite;
PImage rookwhite;
PImage queenwhite;
PImage kingwhite;

PImage pawnblack;
PImage knightblack;
PImage bishopblack;
PImage rookblack;
PImage queenblack;
PImage kingblack;

PImage chessboard;
PImage paw;

PImage intro, gameoverscreen;

PImage imagechosen;

boolean secondclick;
boolean selecting;
boolean reset; 
boolean canmove;

boolean validmove;
boolean ponestep;
boolean ptwostep;
boolean pcaneatleft;
boolean pcaneatright;

boolean leftedge;
boolean rightedge;
boolean upedge;
boolean downedge;
boolean withinbounds;

boolean verticalmove;
boolean horizontalmove;
boolean diagonalmove;
boolean Lmove;

int upstepsallowed = 0;
int downstepsallowed = 0;
int leftstepsallowed = 0;
int rightstepsallowed = 0;

int leftupstepsallowed = 0;
int rightupstepsallowed = 0;
int leftdownstepsallowed = 0;
int rightdownstepsallowed = 0;

boolean kforleft;
boolean kforright;
boolean kbackleft;
boolean kbackright;
boolean kfor;
boolean kback;
boolean kleft;
boolean kright;

int pr;
int pc;
int er;
int ec;

void setup() {
  size(800, 800); 
  myserver = new Server(this, 1234);

  pawnwhite = loadImage("whitepawn.png");
  knightwhite= loadImage("whiteknight.png");
  bishopwhite= loadImage("whitebishop.png");
  rookwhite = loadImage("whiterook.png");
  queenwhite = loadImage("whitequeen.png");
  kingwhite = loadImage("whiteking.png");

  pawnblack = loadImage("blackpawn.png");
  knightblack= loadImage("blackknight.png");
  bishopblack= loadImage("blackbishop.png");
  rookblack = loadImage("blackrook.png");
  queenblack = loadImage("blackqueen.png");
  kingblack = loadImage("blackking.png");

  chessboard = loadImage("board.png");
  paw = loadImage("paw.png");

  intro = loadImage("introscreen.jpg");
  gameoverscreen = loadImage("gameoverscreen.jpg");

  secondclick = false;
  selecting = false;
  reset = false;
  canmove = false;

  validmove = false;

  ponestep = false;
  ptwostep = false; 
  pcaneatleft = false;
  pcaneatright = false;

  kforleft = false;
  kforright = false;
  kbackleft = false;
  kbackright = false;
  kfor = false;
  kback = false;
  kleft= false;
  kright = false;

  leftedge = false;
  rightedge = false;
  upedge = false;
  downedge = false;
  withinbounds = false;

  verticalmove = false;
  horizontalmove = false;
  diagonalmove = false;
  Lmove = false;

  upstepsallowed = 1;
  downstepsallowed = 1;
  leftstepsallowed = 1;
  rightstepsallowed = 1;

  mode = start;
}

void draw() {

  if (mode == start) {
    // reset = true;
    //myserver.write("399"+","+"399"+ "," +"399"+ "," +"399"+ "," +"399");
    imageMode(CORNER);
    image(intro, 0, 0, 800, 800);
    textAlign(CENTER, CENTER);
    textSize(100);
    fill(0, 0, 0);
    text("Chess", 400, 350);

    textSize(50);
    text("Click to start", 400, 450);
    
    //if (reset == true) {
      board[0][0]= rw;
      board[0][1]= nw;
      board[0][2] = bw;
      board[0][3] = kw;
      board[0][4] = qw;
      board[0][5] = bw;
      board[0][6] = nw;
      board[0][7] = rw;

      for (int xw =0; xw<8; xw++) {
        board[1][xw] = pw;
      }
      for (int x =0; x<8; x++) {
        board[2][x] = empty;
      }
      for (int x =0; x<8; x++) {
        board[3][x] = empty;
      }
      for (int x =0; x<8; x++) {
        board[4][x] = empty;
      }
      for (int x =0; x<8; x++) {
        board[5][x] = empty;
      }
      for (int xb =0; xb<8; xb++) {
        board[6][xb] = pb;
      }

      board[7][0]= rb;
      board[7][1]= nb;
      board[7][2] = bb;
      board[7][3] = kb;
      board[7][4] = qb;
      board[7][5] = bb;
      board[7][6] = nb;
      board[7][7] = rb;

      reset = false;
    //}
  } else if (mode == playing) {
    //myserver.write("199"+","+"199"+ "," +"199"+ "," +"199"+ "," +"199");
    imageMode(CORNER);
    image(chessboard, 0, 0, 800, 800);

    int r = 0; 
    int c = 0;

    while (r<8) {


      if (board[r][c] == empty) {
        noStroke();
        fill(255, 255, 255, 0);
        rect(c*100, r*100, 100, 100);
      } else if (board[r][c] == pw ) {
        image(pawnwhite, c*100, r*100, 100, 100);
      } else if (board[r][c] == rw) {
        image(rookwhite, c*100, r*100, 100, 100);
      } else if (board[r][c] == nw) {
        image(knightwhite, c*100, r*100, 100, 100);
      } else if (board[r][c] == bw) {
        image(bishopwhite, c*100, r*100, 100, 100);
      } else if (board[r][c] == qw) {
        image(queenwhite, c*100, r*100, 100, 100);
      } else if (board[r][c] == kw) {
        image(kingwhite, c*100, r*100, 100, 100);
      } else if (board[r][c] == pb ) {
        image(pawnblack, c*100, r*100, 100, 100);
      } else if (board[r][c] == rb) {
        image(rookblack, c*100, r*100, 100, 100);
      } else if (board[r][c] == nb) {
        image(knightblack, c*100, r*100, 100, 100);
      } else if (board[r][c] == bb) {
        image(bishopblack, c*100, r*100, 100, 100);
      } else if (board[r][c] == qb) {
        image(queenblack, c*100, r*100, 100, 100);
      } else if (board[r][c] == kb) {
        image(kingblack, c*100, r*100, 100, 100);
      }
      //if(secondclick != true){
      else if (board[r][c] == selected) {
        stroke(#FA6060);
        strokeWeight(10);
        fill(255, 255, 255, 0);
        rect(c*100, r*100, 100, 100);
      }
      //} else if (board[r][c] == possiblemove) {
      //  stroke(#FCB257);
      //  strokeWeight(10);
      //  fill(255, 255, 255, 0);
      //  rect(c*100, r*100, 100, 100);
      //}
      c++;
      if (c >= 8) {
        r++;
        c = 0;
      }
    }


    if (selecting == true) {
      if ( piecechosen == empty) {
        imagechosen = paw;
      }
      if (piecechosen == pw) {
        imagechosen = pawnwhite;
      }
      if (piecechosen == rw) {
        imagechosen = rookwhite;
      }
      if (piecechosen == nw) {
        imagechosen = knightwhite;
      }
      if (piecechosen == bw) {
        imagechosen = bishopwhite;
      }
      if (piecechosen == qw) {
        imagechosen = queenwhite;
      }
      if (piecechosen == kw) {
        imagechosen = kingwhite;
      }
      if (piecechosen == pb) {
        imagechosen = pawnblack;
      }
      if (piecechosen == rb) {
        imagechosen = rookblack;
      }
      if (piecechosen == nb) {
        imagechosen = knightblack;
      }
      if (piecechosen == bb) {
        imagechosen = bishopblack;
      }
      if (piecechosen == qb) {
        imagechosen = queenblack;
      }
      if (piecechosen == kb) {
        imagechosen = kingblack;
      }

      image(imagechosen, mouseX-50, mouseY-50, 100, 100);
    }

    
    int mr = 0;
    int mc = 0;
    kingcount = 0;
    while (mr < 8) {

      if (board[mr][mc] == kw ||board[mr][mc] == kb ) {
        kingcount++;
        //println("comeon" +kingcount);
      }
      mc++;
      if (mc >=8) {
        mr++;
        mc = 0;
      }
    }
    if (kingcount<2 && selecting == false) {
      myserver.write("299"+","+"299"+","+"299"+","+"299"+","+"299");
      mode = gameover;

    }
  } else if (mode == pawnpromotion) {
    background(215, 185, 120);
    stroke(165, 140, 95);
    line(400, 30, 400, 770);
    line(30, 400, 770, 400);
    imageMode(CENTER);
    image(knightblack, 200, 200, 200, 200);
    image(rookblack, 600, 200, 200, 200);
    image(bishopblack, 200, 600, 200, 200);
    image(queenblack, 600, 600, 200, 200);
  } else if (mode == gameover) {
    //myserver.write("299"+","+"299"+ "," +"299"+ "," +"299"+ "," +"299");
    image(gameoverscreen, 0, 0, 800, 800);
    textAlign(CENTER, CENTER);
    textSize(100);
    fill(0, 0, 0);
    text("GOOD GAME!", 400, 350);

    textSize(50);
    text("Click to Play Again", 400, 450);
  }
  
   
    Client a = myserver.available();
    if ( a != null) {
      String coords = a.readString();
      String[] rc = coords.split(",");
      int piecemoved;

      pr = int( rc[0] );
      pc = int( rc[1] );
      er = int( rc[2] );
      ec = int( rc[3] );
      piecemoved = int(rc[4]);

      //if (pr == 99) {
       // reset = true;
      //}else 
      if(pr == 199){
       mode = playing;
      }else if(pr == 299){
        mode = gameover;
      }else if(pr == 399){
        mode = start;
      } else {
        board[er][ec] = piecemoved;
        board[pr][pc] = empty;
      }
    }
}


void mouseReleased() {

  if (mode == start) {
      println("oo");
    myserver.write("199"+","+"199"+","+"199"+","+"199"+","+"199");
    println("00");
    mode = playing;

  } else if ( mode == playing) {
    imageMode(CORNER);
    

    if (secondclick == false) {
      //selected = 100;
      pr = mouseY/100;
      pc = mouseX/100;
      //if ( board[pr][pc] != empty){
      piecechosen = board[pr][pc];
      if (pc == 7) {
        rightedge = true;
      } else if (pc == 0) {
        leftedge = true;
      } 
      //else {
      //  rightedge = false;
      //  leftedge = false;
      //}
      if (pr == 7) {
        downedge = true;
      } else if (pr == 0) {
        upedge = true;
      } 
      //else {
      //  downedge = false;
      //  upedge = false;
      //}



      for (int i = pr+1; i<=7; i++) {
        downstepsallowed = i-pr;
        if (board[i][pc] > 0) {
          //println("***"+downstepsallowed);
          break;
        }
      }

      for (int i = pr-1; i>=0; i--) {
        upstepsallowed = pr-i;
        if (board[i][pc] != 0) {
          //println("***"+upstepsallowed);
          break;
        }
      }
      for (int i = pc+1; i<=7; i++) {
        rightstepsallowed = i-pc;
        if (board[pr][i] != 0) {
          //println("***"+downstepsallowed);
          break;
        }
      }
      for (int i = pc-1; i>=0; i--) {
        leftstepsallowed = pc-i;
        if (board[pr][i] != 0) {
          //println("***"+downstepsallowed);
          break;
        }
      }


      println("1. " + validmove);
      int a = pr+1;
      int b = pc+1;
      while (a<=7&&b<=7) {

        if (a-pr>=b-pc) {
          rightdownstepsallowed = b-pc;
        } else {
          rightdownstepsallowed = a-pr;
        }
        println("$$"+rightdownstepsallowed);
        if (board[a][b] !=0) {
          break;
        }
        a++;
        b++;
        println("("+b+","+a+")");
      }

      int c = pr-1;
      int d = pc-1;
      while (c>=0&&d>=0) {

        if (pr-c>=pc-d) {
          leftupstepsallowed = pc-d;
        } else {
          leftupstepsallowed = pr-c;
        }
        println("##"+leftupstepsallowed);
        if (board[c][d] !=0) {
          break;
        }
        c--;
        d--;
        println("("+d+","+c+")");
      }

      int e = pr+1;
      int f = pc-1;
      while (e<=7&&f>=0) {

        if (e-pr>=pc-f) {
          leftdownstepsallowed = pc-f;
        } else {
          leftdownstepsallowed = e-pr;
        }
        println("@@"+leftdownstepsallowed);
        if (board[e][f] !=0) {
          break;
        }
        e++;
        f--;
        println("("+f+","+e+")");
      }

      int g = pr-1;
      int h = pc+1;
      while (h<=7&&g>=0) {

        if (pr-g>=h-pc) {
          rightupstepsallowed = h-pc;
        } else {
          rightupstepsallowed = pr-g;
        }
        println("%%"+rightupstepsallowed);
        if (board[g][h] !=0) {
          break;
        }
        h++;
        g--;
        println("("+h+","+g+")");
      }


      //println(piecechosen);
      if (piecechosen == rb) {
        verticalmove = true;
        horizontalmove = true;
      }

      if (piecechosen == bb) {
        diagonalmove = true;
        //for(int i = pc+1; i<=7; i++){
        //for(int j = pr+(i-pc); j<=7;j++){
        //  print("valuei"+i+"valuej"+j);
        //  if(i>=j){

        //    rightdownstepsallowed = j;
        //  }else{
        //    rightdownstepsallowed = i;
        //  }
        //  if(board[j][i] != 0){
        //    //print("haha" + rightdownstepsallowed);

        //    break;
        //  }
        //}
      }
      //    }

      if (piecechosen == qb) {
        verticalmove = true;
        horizontalmove = true;
        diagonalmove = true;
      }

      if (piecechosen == nb) {
        Lmove = true;
      }


      if (piecechosen == kb) {

        if (downedge == true) {
          kfor = true;
          if (leftedge == true) {
            kright = true;
            kforright = true;
          } else if (rightedge == true) {
            kleft = true;
            kforleft = true;
          } else {
            kleft = true;
            kright = true;
            kforleft = true;
            kforright = true;
          }
        } else if (upedge == true) {
          kback = true;
          if (leftedge == true) {
            kright = true;
            kbackright = true;
          } else if (rightedge == true) {
            kleft = true;
            kbackleft = true;
          } else {
            kleft = true;
            kright = true;
            kbackleft = true;
            kbackright = true;
          }
        } else {
          kforleft = true;
          kforright = true;
          kbackleft = true;
          kbackright = true;
          kfor = true;
          kback = true;
          kleft= true;
          kright = true;
        }
      }
      //println("forwardk"+downedge+kfor);
      if (piecechosen == pb) {
          ponestep = true;

        if (pr == 6) {
          ptwostep = true;
          ponestep = true;
          //println(ptwostep);
        } else {
          ptwostep = false;
          ponestep = true;
        }

        if ( pr-1 >=0) {
          //if(leftedge == true){
          //  pcaneatleft = false;
          //  ponestep = true;
          //  pcaneatright = true;
          //}else{
          //  pcaneatleft = true;
          //  ponestep = true;
          //  pcaneatright = true;
          //}

          //if(rightedge ==true){
          //  pcaneatright = false;
          //   ponestep = true;
          //   pcaneatleft = true;
          //}else{
          //  pcaneatright = true;
          //   ponestep = true;
          //   pcaneatleft = true;
          //}



          ponestep = true;
          if (leftedge == true) {
            if (board[pr-1][pc+1] > 0) {
              pcaneatright = true;
              pcaneatleft = false;
            } else {
              pcaneatright = false; 
              pcaneatleft = false;
            }
          } else if (rightedge == true) {
            if (board[pr-1][pc-1] > 0) {
              pcaneatleft = true;
              pcaneatright = false;
            } else {
              pcaneatleft = false; 
              pcaneatright = false;
            }
          } else if ( leftedge == false && rightedge == false) {
            if (board[pr-1][pc-1]>0) {
              pcaneatleft = true;
              ponestep = true;
            }
            if (board[pr-1][pc+1]>0) {
              pcaneatright = true;
              ponestep = true;
            }
          }
        } else {
          pcaneatleft = false;
          pcaneatright = false;
          ptwostep = true;
          ponestep = true;
        }
        //println(ponestep);
      }
      if (piecechosen == pb || piecechosen == rb || piecechosen == kb || piecechosen == bb || piecechosen == nb || piecechosen == qb) {
        canmove = true;
      }



      //selected = board[pr][pc];// = selected;
      if (canmove == true) {
        selecting = true;
        secondclick = true;
        board[pr][pc] = selected;
        //if (validmove == true) {

        //println(board[pr][pc]);
        //}
        //board[pr][pc] = empty;
      }
    } else {
      er = mouseY/100;
      ec = mouseX/100;

      if (er>=0 && er<=7 && ec>= 0 && ec<=7) {
        withinbounds = true;
      }

      if (verticalmove == true) {

        if (ec == pc) {
          if (er-pr > 0 && er-pr <= downstepsallowed) {
            validmove = true;
          }
          println(" A: " + validmove);


          //int a = 1;
          //while (withinbounds == true  && pr+a<=7 ) { //&& board[pr+a][pc] >= 0

          //  validmove = true;
          //  if(board[pr+a][pc]>0){
          //    break; 
          //  }
          //  a++;
          if (pr-er > 0 && pr-er <= upstepsallowed) {
            validmove = true;
          }

          println(" B: " + validmove);


          //}

          //int b = 1;
          //while (withinbounds == true && board[pr-b][ec] >= 0) {
          //  if(board[pr-b][pc]>0){
          //    break; 
          //  }
          //  validmove = true;
          //  b--;
          //}
        }
      }

      if (horizontalmove == true) {
        if (er == pr) {
          if (ec-pc > 0 && ec-pc <= rightstepsallowed) {
            validmove = true;
          }
          if (pc-ec > 0 && pc-ec <= leftstepsallowed) {
            validmove = true;
          }
        }
        println(" C: " + validmove);
      }

      if (diagonalmove == true) {
        if (abs(er-pr)==abs(ec-pc) ) {
          if ( er-pr>0 && er-pr<=rightdownstepsallowed && ec-pc >0 && ec-pc <= rightdownstepsallowed) { 
            validmove = true;
          }
          if ( pr-er>0 && pr-er<=leftupstepsallowed && pc-ec >0 && pc-ec <= leftupstepsallowed) { 
            validmove = true;
          }
          //}
          //if(abs(er-ec)==abs(pr-pc) ){
          if ( pr-er>0 && pr-er<=rightupstepsallowed && ec-pc >0 && ec-pc <= rightupstepsallowed) { 
            validmove = true;
          }
          if ( er-pr>0 && er-pr<=leftdownstepsallowed && pc-ec >0 && pc-ec <= leftdownstepsallowed) { 
            validmove = true;
          }
        }
        //if( er-pr == ec-pc && er-pr <= rightdownstepsallowed){ 
        //  validmove = true; 
        //}
        //if( (pr-er)==(pc-ec) ){
        //  validmove = true;
        //}
        println(" Z: " + validmove);
      }


      if (piecechosen == pb) {
        
        if (er >= 0) {
          if (ptwostep == true) {
            if (ec == pc && pr-er <= 2) {
              validmove = true;
            }
            println(" D: " + validmove);

            //} else {
            //  validmove = false;
            //}
          } 
          //println("****** " + pcaneatleft, pr-er, ec-pc);

          if (pcaneatleft == true) {
            if (pr-er == 1 && ec-pc == -1) {
              validmove = true;
            }

            println(" E: " + validmove);

            //else{
            //  validmove = false;
            //}
          }
          if (pcaneatright == true) {
            if (pr-er == 1 && ec-pc == 1) {
              validmove = true;
            } 
            println(" F: " + validmove);

            //else {
            //  validmove = false;
            //}
          } 
          if (ptwostep == false && pcaneatright == false && pcaneatleft == false) {
            if (ec == pc && pr-er == 1) {
              validmove = true;
            } 
            println(" G: " + validmove);

            //else {
            //  validmove = false;
            //}
          }
          if(ponestep == true){
            if(pr-er ==1 && ec == pc){
              validmove = true;
            }
          }
        } 
        if (validmove == true&&er == 0) {
          mode = pawnpromotion;
        }
        //else { 
        //  validmove = false;
        //}
      } else

        if (piecechosen == kb) {
          if ( kfor == true) {

            if (ec == pc && er-pr == -1) {
              validmove = true;
            }

            println(" H: " + validmove);
          }
          if ( kback == true) {
            if (ec == pc && er-pr==1) {
              validmove = true;
            }
          }
          if ( kleft == true) {
            if (er == pr && pc-ec==1) {
              validmove = true;
            }

            println(" I: " + validmove);
          }
          if ( kright == true) {
            if (er == pr && ec - pc==1) {
              validmove = true;
            }

            println(" J: " + validmove);
          }
          if ( kforleft == true) {
            if (pc-ec== 1 && pr-er==1) {
              validmove = true;
            }

            println(" K: " + validmove);
          }
          if ( kforright == true) {
            if (ec-pc == 1 && pr-er==1) {
              validmove = true;
            }

            println(" K: " + validmove);
          }
          if ( kbackleft == true) {
            if (pc-ec == 1 && er-pr==1) {
              validmove = true;
            }
            println(" K: " + validmove);
          }
          if ( kbackright == true) {
            if (ec-pc==1 && ec-pc==1) {
              validmove = true;
            }
            println(" K: " + validmove);
          }
        } 
      //else {
      //  validmove = false;
      //}

      //println("****** " + kfor, pr-er, ec-pc, validmove);
      //println(validmove);
      if (piecechosen == nb) {
        if (abs(er-pr)==1 && abs(ec-pc) == 2) {
          validmove = true;
        }
        if (abs(ec-pc)==1 && abs(er-pr) == 2) {
          validmove = true;
        }
      }

      println(" J: " + validmove);
      if (board[er][ec]*piecechosen <= 0 && validmove == true) {
        println("2. " + validmove);

        myserver.write(pr+","+pc+ "," +er+ "," +ec+ "," +piecechosen);
        board[pr][pc] = empty;

        board[er][ec] = piecechosen;
      } else {
        board[pr][pc] = piecechosen;
      }
      
    
      
      piecechosen = empty;
      selecting = false;

      //println(board[er][ec]);

      secondclick = false;
      canmove = false;
      validmove = false;

      ponestep = false;
      ptwostep = false;
      pcaneatleft = false;
      pcaneatright = false;
      leftedge = false;
      rightedge = false;
      
    }
  } else if (mode == pawnpromotion) {
    if (mouseX<400 && mouseY<400) {
      promotedpawn = nb;
    } else if (mouseX>400 &&mouseY<400) {
      promotedpawn = rb;
    } else if (mouseX<400 &&mouseY>400) {
      promotedpawn = bb;
    } else if (mouseX>400 &&mouseY>400) {
      promotedpawn = qb;
    }
    
    board[er][ec] = promotedpawn;
    myserver.write(pr+","+pc+ "," +er+ "," +ec+ "," +promotedpawn);
    println("peekaboo"+promotedpawn);
    mode = playing;
  } else if (mode == gameover) {
    myserver.write("399"+","+"399"+","+"399"+","+"399"+","+"399");

    mode = start;
  }
}

void keyReleased() {
  if (mode == playing) {
    if (key == BACKSPACE) {
      mode = gameover;
      println(mode);
    }

    if (key == ENTER) {
      reset = true;
      
    }
  }
}