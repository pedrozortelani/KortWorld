extends Control

var inputHandler
var index = 0

onready var statsBtn = get_node("Buttons/StatsBtn")
onready var statsPage = get_node("SubMenus/Stats")
onready var inventoryPage = get_node("SubMenus/Inventory")
onready var worldMapPage = get_node("SubMenus/WorldMap")

func _process(delta):
	if visible:
		if index == 0:
			if Input.is_action_just_pressed("ui_cancel"):
				closeMenu()
		else:
			if worldMapPage.visible:
				if Input.is_action_just_pressed("ui_cancel"):
					worldMapPage.visible = false
					index = 0;
					statsBtn.grab_focus()

func closeMenu():
	inputHandler.action = InputHandler.STATE.Idle
	inventoryPage.visible = false
	visible = false

func _on_StatsBtn_pressed():
	statsPage.visible = true
	statsPage.mainmenu = self
	statsPage.playerStats = inputHandler.get_node("Attributes")
	get_focus_owner().release_focus()
	statsPage.active = true
	statsPage.strBtn.grab_focus()
	statsPage.atualizeUI()
	index = 1

func _on_InventoryBtn_pressed():
	inventoryPage.visible = true
	get_focus_owner().release_focus()
	inventoryPage.active = true
	inventoryPage.index = 0
	inventoryPage.inventoryindex = 0
	inventoryPage.itemindex = 1
	inventoryPage.atualizeInventory()
	inventoryPage.atualizeStats()
	inventoryPage.atualizeDescription()
	index = 1

func _on_QuitGameBtn_pressed():
	get_tree().quit()

func _on_WorldMapBtn_pressed():
	worldMapPage.visible = true
	get_focus_owner().release_focus()
	index = 1



