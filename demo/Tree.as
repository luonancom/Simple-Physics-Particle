package 
{
	import cn.flashhawk.spp.canvas.CanvasBMD;
	import cn.flashhawk.spp.geom.Vector2D;
	import cn.flashhawk.spp.particles.*;

	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	/**
	 * @author flashhawk
	 */
	[SWF(backgroundColor="#000000", frameRate="30", width="1000", height="700")]

	public class Tree extends Sprite 
	{

		private var ps : ParticlesSystem = new ParticlesSystem(Particle);
		private var level : int =11;
		private var branchCount : int = 2;
		private var branchWidth : Number = 30;

		private var canvasBmd : CanvasBMD;
		private var canvas : Bitmap;

		private var r : Number = 255; 
		private var g : Number = 127; 
		private var b : Number = 0; 

		private var ri : Number = 0.02;
		private var gi : Number = 0.015; 
		private var bi : Number = 0.025;

		private var isCanClick : Boolean = false;
		
		private var l:int;

		public function Tree()
		{
			
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e : Event) : void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.doubleClickEnabled = true;
			stage.addEventListener(MouseEvent.DOUBLE_CLICK, function(e : MouseEvent):void
			{
				if(stage.displayState != StageDisplayState.FULL_SCREEN)
				{
					stage.displayState = StageDisplayState.FULL_SCREEN;
				}
				else
				{
					stage.displayState = StageDisplayState.NORMAL;
				}
			});
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(MouseEvent.CLICK, function(e : MouseEvent):void
			{
				initCanvas();
			});
			stage.addEventListener(Event.RESIZE, initCanvas);
			initCanvas();
			ps.startRendering();
		}

		private function initCanvas(e : Event = null) : void
		{
			removeAll();
			if(canvasBmd != null)canvasBmd.dispose();
			if(canvas != null)removeChild(canvas);
			canvasBmd = new CanvasBMD(stage.stageWidth, stage.stageHeight);
			canvas = new Bitmap(canvasBmd);
			canvas.width = stage.stageWidth;
			canvas.height = stage.stageHeight;
			addChild(canvas);
			
			run();
		}

		private function onEnterFrame(event : Event) : void 
		{
			var color : uint = (Math.sin(r += ri) * 128 + 127) << 16 | (Math.sin(g += gi) * 128 + 127) << 8 | (Math.sin(b += bi) * 128 + 127) ;
			l = ps.particles.length;
			canvasBmd.lock();
			while(l-- > 0)
			{
				var rectWdith : Number = branchWidth / ps.particles[l].extra.level;
				if(ps.particles[l].extra.level == 1)rectWdith = 20;
				canvasBmd.fillRect(new Rectangle(ps.particles[l].x - rectWdith / 2, ps.particles[l].y, rectWdith, 1), color);
			}
			canvasBmd.unlock();
		}

		private function run() : void
		{
			isCanClick = false;
			canvasBmd.clear();
			var p :Particle = ps.createParticle();
			p.init(stage.stageWidth / 2, stage.stageHeight, 1*30);
			p.addEventListener("dead", deadHandler);
			p.extra.level=1;
			p.v = new Vector2D(0, -4);
			p.f = new Vector2D(0, 0);
		
			
		}

		public function createParticle(x : Number,y : Number,v : Vector2D,parentLevel : int) : void
		{
			var p : Particle = ps.createParticle();
			p.init(x, y, 0.5*30);
			p.extra.level=parentLevel + 1;
			if(p.extra.level < level)
			p.addEventListener("dead", deadHandler);
			p.v =v.clone();
			p.v.rotate(30-Math.random()*60);
			p.f = new Vector2D(0, 0);
			trace(ps.particles.length);
		
		}
		private function removeAll():void
		{
			var n:int=ps.particles.length;
			while(n-- > 0)
			{				
				ps.particles[n].removeEventListener("dead", deadHandler);
			}
			ps.removeAllParticles();
		}
		private function deadHandler(e : Event) : void
		{
			var particle : Particle = Particle(e.target);
			particle.removeEventListener("dead", deadHandler);
			var j : int = branchCount;
			while(j-- >0)
			{
				createParticle(particle.x, particle.y, particle.v,particle.extra.level);
			}
		}
		private function createBall(color : uint,r : Number = NaN) : Sprite
		{
			var s : Sprite = new Sprite();
			s.cacheAsBitmap = true;
			s.graphics.beginFill(color);
			s.graphics.drawCircle(0, 0, r);
			s.graphics.endFill();
			return s;
		}
	}
}
