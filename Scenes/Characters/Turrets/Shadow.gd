extends Sprite


onready var shadowTween = $ShadowTween


func flash_shadow():
	shadowTween.interpolate_property(self, 'modulate', Color(1,1,1,0.3),
	 Color(1,1,1,1), 0.18, Tween.TRANS_BOUNCE, Tween.EASE_IN)
	shadowTween.start()
