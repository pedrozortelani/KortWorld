extends KinematicBody2D

class_name InputHandler

onready var animator = $AnimatedSprite
onready var mainmenu = get_tree().root.get_node("Game/MainMenu/MainMenu")
onready var combatHandler = get_tree().root.get_node("Game/Combat")

var cur_direction = DIRECTION.Front
var nxt_direction = DIRECTION.Front
var velocity = Vector2.ZERO
var speed = 80

var hasTalisman = false
var steps = 0

var interactionObj = null
var action = STATE.Idle

enum DIRECTION{Side, Front, Back}
enum STATE{Idle, Talking, Occupied}

func _process(delta):
	velocity = Vector2.ZERO
	move(delta)
	interact()

func move(delta):
	if action == STATE.Idle:
		if Input.is_action_pressed("ui_up"):
			velocity.y = -1
			animator.set_flip_h(false);
			cur_direction = DIRECTION.Back
		elif Input.is_action_pressed("ui_left"):
			velocity.x = -1
			animator.set_flip_h(true);
			cur_direction = DIRECTION.Side
		elif Input.is_action_pressed("ui_right"):
			velocity.x = 1
			animator.set_flip_h(false);
			cur_direction = DIRECTION.Side
		elif Input.is_action_pressed("ui_down"):
			velocity.y = 1
			animator.set_flip_h(false);
			cur_direction = DIRECTION.Front
	
	animate()
	move_and_collide(velocity * delta * speed)
	
	if velocity != Vector2.ZERO and hasTalisman:
		steps -= 1
		if steps <= 0:
			hasTalisman = false

func interact():
	if action == STATE.Idle:
		if Input.is_action_just_pressed("ui_accept"):
			if interactionObj != null:
				interactionObj.interact(self)
		if Input.is_action_just_pressed("ui_select"):
			openMenu()

func animate():
	if velocity.x < 0:
		animator.play("walkSide")
	elif velocity.x > 0:
		animator.play("walkSide")
	elif velocity.y < 0:
		animator.play("walkBack")
	elif velocity.y > 0:
		animator.play("walkFront")
	elif velocity == Vector2.ZERO:
		if cur_direction == DIRECTION.Front:
			animator.play("idleFront")
		elif cur_direction == DIRECTION.Side:
			animator.play("idleSide")
		elif cur_direction == DIRECTION.Back:
			animator.play("idleBack")

func openMenu():
	action = STATE.Occupied
	mainmenu.visible = true
	mainmenu.inputHandler = self
	mainmenu.statsBtn.grab_focus()

func takeTurn():
	combatHandler.menuindex = 1
	combatHandler.menutype = "Action"
	combatHandler.actionselector.visible = true
	combatHandler.actionselector.get_parent().remove_child(combatHandler.actionselector)
	combatHandler.get_node("CombatInterface/UI/ActionMenu/Option" + str(combatHandler.menuindex)).add_child(combatHandler.actionselector)
	combatHandler.active = true
