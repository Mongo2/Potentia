extends KinematicBody2D

var mVelocity
export var mAcceleration = 1.0
export var mShockCooldown = 1.0
export var mPowerDepletion = 10

var canShock
var mSleigh
var mPower
var mAggression

var mPowerBar
var mAggressionBar

func _fixed_process(delta):
	if (!is_colliding()):
		mVelocity.y += globals.GRAVITY
	else:
		mVelocity.y = 0
	
	if (Input.is_action_pressed("Shock") and canShock):
		canShock = false
		get_node("ShockTimer").start()
		mVelocity.x += mAcceleration
		mPower -= mPowerDepletion
		mAggression = 0
		mPowerBar.set_value(mPower)
		mAggressionBar.set_value(mAggression)
	
	
	var motion = mVelocity * delta
	var mx = motion.x
	motion = move(motion)
	mSleigh.set_velocity(mVelocity.x)
	if (is_colliding()):
		var n = get_collision_normal()
		if (n.y != -1):
			motion.y = n.slide(motion).y
			mVelocity.y = n.slide(mVelocity).y
		
		move(Vector2(0, motion.y))
	
func _ready():
	mPower = 100
	mAggression = 0
	mPowerBar = get_parent().get_node("Hud/HBoxContainer/Bars/Power")
	mAggressionBar = get_parent().get_node("Hud/HBoxContainer/Bars/Aggression")
	canShock = true
	mVelocity = Vector2()
	mSleigh = get_parent().get_node("Sledge")
	set_fixed_process(true)

func _on_ShockTimer_timeout():
	canShock = true