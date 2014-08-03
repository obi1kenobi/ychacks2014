/*///////////////////////////////////////////////////////////////////////////////

  Author: Matthaeus Krenn
	Website: http://matthaeuskrenn.com
	Date: May 2013
	Description: springTo.js makes spring-physics-based movement of elements on websites
	             accessible to anyone via one simplest possible line of code.
	             while not ready for prime-time, it's a handy tool to simple protoype
	             delightful and responsive interactions within a browser.
  
  Copyright (c) 2013 Matthaeus Krenn

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
  THE SOFTWARE.
  
///////////////////////////////////////////////////////////////////////////////////*/



// easy non-jquery dom element selection
function getEl(query) {
  return document.querySelector(query);
}





// the function used to move an element
function elementSpringTo(domElement, x, y, springParameters, delay, xSpeed, ySpeed) {
  var domEl = getEl(domElement);
  
  //checks whether a XYSpring has been added to the dom element
  //if yes, the XYSpring will be reused, if not, it will be created
  if (typeof domEl.spring == 'undefined') {
    domEl.spring = new XYSpring(domEl, x, y, springParameters, domElement, delay, xSpeed, ySpeed);
  } else {
    domEl.spring.moveTo(x, y, springParameters, delay, xSpeed, ySpeed);
  }
}



//can be used to stop any XYSpring motion
function elementSpringStop(domElement) {
  var domEl = getEl(domElement);
  domEl.spring.stop();
}





// XYSpring constructor.

// parameters: The DOM element that has been returned by the querySelector
// domElement: The unique identifier for the element you want to move.
// x: Horizontal target position. (px)
// y: Vertical target position. (px)
// springParameters: The combination of these values defines the characteristics of the movement: spring stiffness, object mass, friction. (optional) 
// originalElementName: The original unique identifier for the element you want to move.
// delay: Delay before movement begins. (ms) (optional)
// xSpeed: Horizontal speed at beginning of movement. (optional)
// ySpeed: Vertical speed at beginning of movement. (optional)

// uses mSpring.js (http://matthaeuskrenn.com/mspring) for spring-physics calculation
// creates two mSprings. One for horizontal, one for vertical movement calculations
// adds the XYSpring to the dom element and sets it in motion
function XYSpring(domElement, x, y, springParameters, originalElementName, delay, xSpeed, ySpeed) {
  var s = this;
  s.domEl = domElement;
  s.trigger = false;
  s.originalElementName = originalElementName;


  // check whether element has been assigned absolute, relative or fixed position.
  var domElPosition = window.getComputedStyle(s.domEl,null).getPropertyValue('position');
  // If neither, it changes position style to relative in order to be able to move the element
  if (domElPosition == 'static' ) {
    s.domEl.style.position = 'relative';
    s.domEl.style.left = '0px';
    s.domEl.style.top = '0px';
    // console.log('static element changed to relative');
  }
  
  
  
  var xOnSpringChange, yOnSpringChange;
  
  // check whether element is positioned via top/bottom and left/right style property
  // this is necessary to apply the movement to the appropriate style properties of the element
  if (window.getComputedStyle(s.domEl,null).getPropertyValue('right') != 'auto') {
    s.domElXPosProperty = 'right';
    // console.log('element positioned right');
    xOnSpringChange = function(massPos, springData) {
      s.domEl.style.right = massPos + 'px';
    }
  } else {  
    s.domElXPosProperty = 'left';
    // console.log('element positioned left');
    xOnSpringChange = function(massPos, springData) {
      s.domEl.style.left = massPos + 'px';
    }
  }
  
  if (window.getComputedStyle(s.domEl,null).getPropertyValue('bottom') != 'auto') {
    s.domElYPosProperty = 'bottom';
    // console.log('element positioned bottom');
    yOnSpringChange = function(massPos, springData) {
      s.domEl.style.bottom = massPos + 'px';
    }
  } else {  
    s.domElYPosProperty = 'top';
    // console.log('element positioned top');
    yOnSpringChange = function(massPos, springData) {
      s.domEl.style.top = massPos + 'px';
    }
  }
  
  
  // mSprings are being created using the appropriate onSpringChange function 
  s.xSpring = new mSpring({
  	onSpringStart: function() {
  	},
  	onSpringChange: xOnSpringChange,
  	
  	onSpringRest: function() {
  	}	
  });
  
  s.ySpring = new mSpring({
  	onSpringStart: function() {
  	},
  	onSpringChange: yOnSpringChange,
  	
  	onSpringRest: function() {
  	}	
  });
  
  
  s.moveTo(x, y, springParameters, delay, xSpeed, ySpeed);
} 




//initiates movement of an element to new x and y coordinates
XYSpring.prototype.moveTo = function(x, y, springParameters, delay, xSpeed, ySpeed) {
  var s = this;
  s.delay = delay || 0;
  var xS = xSpeed*100 || 0;
  var yS = ySpeed*100 || 0;
  
  
  
  clearTimeout(s.trigger);
  s.trigger = setTimeout(function() {
  
    // checks whether springParemeters are set. If not, sets them to default value
    if (typeof springParameters != 'undefined') {
      s.xSpring.setSpringParameters(springParameters[0], springParameters[1], springParameters[2]);
      s.ySpring.setSpringParameters(springParameters[0], springParameters[1], springParameters[2]);
    } else {
      s.xSpring.setSpringParameters(120, 10, 3);
      s.ySpring.setSpringParameters(120, 10, 3);
    }
  
    // sets current element position as origin of spring anchor and mass to avoid movements overlapping
    s.xSpring.anchorPos = parseInt(window.getComputedStyle(s.domEl,null).getPropertyValue(s.domElXPosProperty)); //only compatible with IE 9+
    s.xSpring.massPos = parseInt(window.getComputedStyle(s.domEl,null).getPropertyValue(s.domElXPosProperty)); //only compatible with IE 9+
  
    s.ySpring.anchorPos = parseInt(window.getComputedStyle(s.domEl,null).getPropertyValue(s.domElYPosProperty)); //only compatible with IE 9+
    s.ySpring.massPos = parseInt(window.getComputedStyle(s.domEl,null).getPropertyValue(s.domElYPosProperty)); //only compatible with IE 9+
  
  
    // starts the movement via the individual mSprings
    s.xSpring.start(undefined, undefined, xS, x);
    s.ySpring.start(undefined, undefined, yS, y);
  
  }, s.delay);
}



//stops all movement of the spring.
XYSpring.prototype.stop = function(x, y, springParameters, delay) {
  var s = this;
  s.xSpring.stop();
  s.ySpring.stop();
}













// mSpring.js (http://matthaeuskrenn.com/mspring) for spring-physics calculation
function mSpring(options) {
	var spring = this;
	this.options = options;
	
	//triggers one calculation cycle to change the spring.
	this.stepTrigger = false;
	
	//initiates the spring Class
	spring.init();
	
	//assings the function that is called each time the spring starts from rest state.
	spring.onSpringStart = options.onSpringStart;
	
	//assings the function that is called each time the spring changes.
	spring.onSpringChange = options.onSpringChange;
	
	//assigns the funtion that is called when the spring goes to a rest state.
	spring.onSpringRest = options.onSpringRest;
}



mSpring.prototype.init = function () {
	var spring = this;
	
	spring.anchor = 0;
	spring.interval = 1000 / 60;
  spring.end = 0;
  spring.acceleration = 0;
	spring.distance = 0;
	spring.speed = 0;
	spring.springForce = 0;
	spring.dampingForce = 0;
	spring.totalForce = 0;
	spring.anchorPos = 0;
	spring.massPos = 0;
	
	//sets the constant spring parameters to a useful standard, 120, 10, 3
	spring.setSpringParameters(120, 10, 3);
}




//this gives the spring an impulse
//impulses can also be given while spring is in motion in order to alter its state
mSpring.prototype.start = function (acceleration, massPos, speed, anchorPos) {
	var spring = this;
	
	spring.onSpringStart();
	
	spring.massPos = (typeof massPos != 'undefined') ? massPos : spring.massPos;
	
	spring.speed = (typeof speed != 'undefined') ? speed : spring.speed;
	
	spring.speed += acceleration*10 || 0;
	
	spring.anchorPos = (typeof anchorPos != 'undefined') ? anchorPos : spring.anchorPos;

	spring.step();
}



//one step is one recalculation of all spring variables when in motion
mSpring.prototype.step = function () {
	var spring = this;
	
	spring.distance = spring.massPos - spring.anchorPos;
	
  spring.dampingForce = -spring.friction * spring.speed;
    
	spring.springForce = -spring.stiffness * spring.distance;

  spring.totalForce = spring.springForce + spring.dampingForce;

  spring.acceleration = spring.totalForce / spring.mass;

  spring.speed += spring.acceleration;

  spring.massPos += spring.speed/100;

	if (Math.round(spring.massPos) == spring.anchorPos && Math.abs(spring.speed) < 0.2) {
		spring.removeStepTrigger();
	} else {		
		spring.onSpringChange(Math.round(spring.massPos), {	distance: spring.distance,
															acceleration: spring.acceleration,
															speed: spring.speed });
		spring.setStepTrigger();
	}
}






//this gives the spring an impulse
//impulses can also be given while spring is in motion in order to alter its state
mSpring.prototype.stop = function (acceleration, massPos, speed, anchorPos) {
	var spring = this;
	
  spring.removeStepTrigger();
	
	spring.massPos = spring.anchorPos;
	
	spring.speed = 0;
	
  // spring.speed += acceleration*10 || 0;
	
  // spring.anchorPos = (typeof anchorPos != 'undefined') ? anchorPos : spring.anchorPos;

  // spring.step();
}






//use this to change the spring parameters
mSpring.prototype.setSpringParameters = function (stiffness, mass, friction) {
	var spring = this;
	
	spring.stiffness = stiffness;
  spring.mass = mass;
  spring.friction = friction;
}



//use this to get the spring parameters
mSpring.prototype.getSpringParameters = function () {
	var spring = this;
	
	return {
		stiffness: spring.stiffness,
		mass: spring.mass,
		friction: spring.friction
	};
}


//this sets the timer for the next step
mSpring.prototype.setStepTrigger = function () {
	var spring = this;
	clearTimeout(spring.stepTrigger);
	spring.stepTrigger = setTimeout(function () {spring.step()}, spring.interval);
}



//this stops the spring from performing the next step
mSpring.prototype.removeStepTrigger = function () {
	var spring = this;
	spring.stepTrigger = false; //removeTimeout(spring.step(), 10);
	spring.onSpringRest();
}



//this assigns a new function to be called when the spring starts to move
mSpring.prototype.setOnSpringStart = function (onSpringStart) {
	var spring = this;
	spring.onSpringStart = onSpringStart;
}


//this assigns a new function to be called at each spring calculation cycle
mSpring.prototype.setOnSpringChange = function (onSpringChange) {
	var spring = this;
	spring.onSpringChange = onSpringChange;
}


//this assigns a new function to be called when the spring stops moving
mSpring.prototype.setOnSpringRest = function (onSpringRest) {
	var spring = this;
	spring.onSpringChange = onSpringRest;
}











