﻿package cn.flashhawk.spp.particles 
{
	import flash.geom.Rectangle;

	/**
	 * 有矩形边界的粒子,这些粒子被约束在一个矩形里面
	 * @author FLASHHAWK
	 */
	public class BoundParticle extends Particle
	{
		private var _particleBound : Rectangle;
		private var _top : Number;
		private var _bottom : Number;
		private var _left : Number;
		private var _right : Number;
		/*
		 * 碰到边界时候的反弹强度,默认是2
		 */
		public 	var  bounceIntensity : Number = 2;

		/**
		 * 
		 * @param	target 显示对象目标
		 * @param	x
		 * @param	y
		 * @param	bound  边界
		 */
		public function BoundParticle() 
		{
			
		}
		/**
		 * @private
		 */
		override protected function move() : void 
		{
			super.move();
			bounce();
		}

		/**
		 * @private
		 * 反弹的算法,可以继承或者覆盖次方法，来定义你的反弹算法
		 */
		protected function bounce() : void
		{
			defaultBounce();
		}

		/**
		 * 默认的反弹算法
		 */
		private function defaultBounce() : void
		{
			
			if (position.x < _left || position.x > _right)
			{
				
				position.x = position.x < _left ? _left : _right;
				v.scaleX(-bounceIntensity);
				a.scale(0);
			}
			if (position.y < _top || position.y > _bottom)
			{
				
				position.y = position.y < _top ? _top : _bottom;
				v.scaleY(-bounceIntensity);
				a.scale(0);
			}
		}

		/**
		 * 返回或设置矩形边界
		 */
		public function get particleBound() : Rectangle
		{
			return _particleBound;
		}

		/**
		 * @private
		 */
		public function set particleBound(bound : Rectangle) : void
		{
			_particleBound = bound;
			if(this.target != null)
			{
				_left = bound.left + this.target.width / 2;
				_right = bound.right - this.target.width / 2;
				_top = bound.top + this.target.height / 2;
				_bottom = bound.bottom - this.target.height / 2;
			}
			else
			{
				_left = bound.left;
				_right = bound.right;
				_top = bound.top ;
				_bottom = bound.bottom;
			}
		}
	}
}