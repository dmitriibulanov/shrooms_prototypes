extends Node2D

@export_group("Expedition")
@export_range(1, 500, 1) var initial_people: int = 50
@export_range(0, 100000, 1) var initial_supplies: int = 500
@export_range(1, 100, 1) var supplies_per_person: int = 1
@export_range(0.0, 1.0, 0.01) var hunger_damage_loss: float = 0.3
@export_range(1, 20, 1) var hunger_death_steps: int = 3
@export_range(0.0, 1.0, 0.05) var post_battle_health_floor: float = 0.5

@export_group("Logistics")
@export_range(0.0, 1.0, 0.01) var convoy_ambush_chance: float = 0.05
@export_range(1, 100, 1) var carry_capacity_per_person: int = 15
@export_range(1, 100, 1) var artifact_weight: int = 5
@export_range(1, 100, 1) var coins_per_weight: int = 10

@export_group("Economy")
@export_range(0, 1000, 1) var money_per_monster: int = 1
@export_range(0, 10000, 1) var money_per_boss: int = 25
@export_range(1, 10000, 1) var artifact_sale_price: int = 50
@export_range(0.0, 2.0, 0.01) var artifact_attack_growth: float = 0.2
@export_range(1, 10000, 1) var kitchen_purchase_price: int = 50
@export_range(1, 10000, 1) var camp_purchase_price: int = 75
@export_range(1, 10000, 1) var lab_purchase_price: int = 75
@export_range(1, 10000, 1) var hospital_purchase_price: int = 75
@export_range(0, 20, 1) var initial_kitchen_slots: int = 1
@export_range(0, 20, 1) var initial_camp_slots: int = 0
@export_range(0, 20, 1) var initial_lab_slots: int = 0
@export_range(0, 20, 1) var initial_hospital_slots: int = 0

@export_group("Buildings")
@export_range(1, 20, 1) var building_worker_capacity: int = 5
@export_range(0, 100, 1) var kitchen_food_per_worker: int = 10
@export_range(0.0, 1.0, 0.01) var camp_attack_per_worker: float = 0.1
@export_range(0.0, 0.95, 0.01) var lab_reduction_per_worker: float = 0.1
@export_range(0.0, 0.95, 0.01) var lab_max_reduction: float = 0.7

@export_group("Battle Window")
@export_range(0.5, 0.95, 0.01) var battle_window_scale: float = 0.8

@export_group("Meta Progression")
@export_range(1, 100, 1) var meta_people_bonus: int = 10
@export_range(0.0, 1.0, 0.01) var meta_attack_growth: float = 0.1
@export_range(0.0, 1.0, 0.01) var meta_enemy_growth: float = 0.1

@export_group("Map")
@export_range(1, 20, 1) var map_columns: int = 5
@export_range(1, 20, 1) var map_rows: int = 10
@export var start_cell: Vector2i = Vector2i(3, 1)
@export var goal_cell: Vector2i = Vector2i(5, 10)

var cell_enemy_variation: Dictionary = {}

@export_group("Enemy Randomization")
@export_range(0.0, 0.9, 0.05) var enemy_count_variation: float = 0.25
@export_range(0.0, 1.0, 0.05) var enemy_composition_variation: float = 0.75
@export_range(0.0, 30.0, 1.0) var enemy_spawn_jitter: float = 14.0

@export_group("Enemy Count")
@export_range(1, 500, 1) var first_floor_enemies: int = 32
@export_range(1.0, 10.0, 0.1) var last_floor_enemy_multiplier: float = 3.0
@export_range(0.0, 1.0, 0.05) var heavy_enemy_share: float = 0.25

@export_group("Ranged Mushrooms")
@export_range(0.0, 1.0, 0.05) var ranged_enemy_share: float = 0.2
@export_range(1.0, 1000.0, 1.0) var ranged_hp: float = 25.0
@export_range(1.0, 500.0, 1.0) var ranged_speed: float = 45.0
@export_range(0.1, 500.0, 0.1) var ranged_damage: float = 4.0
@export_range(0.05, 10.0, 0.05) var ranged_interval: float = 1.2
@export_range(30.0, 500.0, 5.0) var ranged_attack_range: float = 220.0
@export_range(50.0, 1000.0, 10.0) var spore_speed: float = 260.0
@export_range(1.0, 30.0, 1.0) var ranged_radius: float = 8.0

@export_group("Fast Mushrooms")
@export_range(0.0, 1.0, 0.05) var fast_enemy_share: float = 0.2
@export_range(1.0, 1000.0, 1.0) var fast_hp: float = 20.0
@export_range(1.0, 500.0, 1.0) var fast_speed: float = 125.0
@export_range(0.1, 500.0, 0.1) var fast_damage: float = 6.0
@export_range(0.05, 10.0, 0.05) var fast_interval: float = 0.65
@export_range(1.0, 30.0, 1.0) var fast_radius: float = 6.0

@export_group("Boss")
@export_range(100.0, 20000.0, 50.0) var boss_hp: float = 3000.0
@export_range(1.0, 300.0, 1.0) var boss_speed: float = 50.0
@export_range(1.0, 500.0, 1.0) var boss_damage: float = 28.0
@export_range(0.1, 10.0, 0.1) var boss_attack_interval: float = 1.2
@export_range(20.0, 100.0, 1.0) var boss_radius: float = 30.0
@export_range(30.0, 300.0, 5.0) var boss_attack_range: float = 100.0
@export_range(50.0, 400.0, 5.0) var boss_blast_radius: float = 150.0

@export_group("Rewards")
@export_range(1, 100, 1) var reward_people: int = 5
@export_range(0.0, 2.0, 0.01) var reward_enemy_growth: float = 0.1
@export_range(0.0, 2.0, 0.01) var reward_attack_growth: float = 0.1

@export_group("Events")
@export_range(0.0, 2.0, 0.01) var event_attack_growth: float = 0.1
@export_range(1, 100, 1) var event_new_people: int = 10
@export_range(0.0, 2.0, 0.01) var event_enemy_growth: float = 0.1
@export_range(1.0, 10.0, 0.1) var event_enemy_multiplier: float = 2.0
@export_range(1.0, 10.0, 0.1) var event_attack_multiplier: float = 2.0

@export_group("Humans")
@export_range(1.0, 1000.0, 1.0) var human_hp: float = 40.0
@export_range(1.0, 500.0, 1.0) var human_speed: float = 68.0
@export_range(0.1, 500.0, 0.1) var human_damage: float = 6.0
@export_range(0.05, 10.0, 0.05) var human_attack_interval: float = 0.75
@export_range(1.0, 30.0, 1.0) var human_radius: float = 7.0

@export_group("Classes")
@export_range(30.0, 500.0, 5.0) var shooter_range: float = 180.0
@export_range(1.0, 4.0, 0.1) var scientist_range_multiplier: float = 2.0
@export_range(0.05, 0.5, 0.01) var scientist_laser_duration: float = 0.12
@export_range(50.0, 1000.0, 10.0) var projectile_speed: float = 420.0
@export var warrior_hp_multiplier: float = 1.2
@export var warrior_damage_multiplier: float = 2.0
@export var scientist_hp_multiplier: float = 0.6
@export var scientist_damage_multiplier: float = 0.6
@export var cook_hp_multiplier: float = 1.2
@export var cook_damage_multiplier: float = 0.4
@export_range(1.0, 5.0, 0.1) var scientist_work_multiplier: float = 2.0
@export_range(1.0, 5.0, 0.1) var cook_work_multiplier: float = 2.0

@export_group("Kiting")
@export_range(20.0, 300.0, 5.0) var shooter_retreat_distance: float = 100.0
@export_range(20.0, 400.0, 5.0) var scientist_retreat_distance: float = 160.0
@export_range(0.1, 1.0, 0.05) var retreat_speed_multiplier: float = 0.65
@export_range(0.1, 2.0, 0.05) var max_retreat_duration: float = 0.6
@export_range(0.1, 3.0, 0.05) var retreat_recovery: float = 0.8
@export_range(0.05, 1.0, 0.05) var ranged_aim_time: float = 0.2
@export_range(0.05, 1.0, 0.05) var ranged_shot_pause: float = 0.2

@export_group("Normal Mushrooms")
@export_range(1.0, 1000.0, 1.0) var mushroom_hp: float = 30.0
@export_range(1.0, 500.0, 1.0) var mushroom_speed: float = 55.0
@export_range(0.1, 500.0, 0.1) var mushroom_damage: float = 5.0
@export_range(0.05, 10.0, 0.05) var mushroom_attack_interval: float = 0.95
@export_range(1.0, 30.0, 1.0) var mushroom_radius: float = 7.0

@export_group("Heavy Mushrooms")
@export_range(1.0, 1000.0, 1.0) var heavy_hp: float = 65.0
@export_range(1.0, 500.0, 1.0) var heavy_speed: float = 34.0
@export_range(0.1, 500.0, 0.1) var heavy_damage: float = 12.0
@export_range(0.05, 10.0, 0.05) var heavy_attack_interval: float = 1.3
@export_range(1.0, 30.0, 1.0) var heavy_radius: float = 12.0

const FIELD := Rect2(30, 115, 1040, 540)
var units: Array[Dictionary] = []
var elapsed := 0.0
var finished := false
var status: Label
var result: Label
var rng := RandomNumberGenerator.new()
var map_position := Vector2i(3, 1)
var map_panel: Control
var map_buttons: Array[Button] = []
var on_map := false
var expedition_complete := false
var visited: Array[Vector2i] = []
var battle_number := 0
var expedition_size := 0
var supplies := 0
var people: Array[Dictionary] = []
var step_number := 0
var last_starved_deaths := 0
var enemy_multiplier := 1.0
var attack_multiplier := 1.0
var starting_humans := 50
var starting_enemies := 32
var choices: Panel
var choice_title: Label
var awaiting_choice := false
const BUILDING_NAMES := ["Временный лагерь", "Полевая кухня", "Полевая лаба", "Полевой лазарет"]
const BUILDING_MARKERS := ["Л", "К", "Лб", "+"]
var buildings: Dictionary = {}
var construction_overlay: ColorRect
var construction_title: Label
var construction_buttons: Array[Button] = []
var cell_events: Dictionary = {}
var event_overlay: ColorRect
var event_label: Label
var pending_event: int = -1
const META_SAVE := "user://shrooms_meta.cfg"
var meta_people_level := 0
var meta_attack_level := 0
var meta_enemy_level := 0
var meta_upgrade_available := false
var run_active := false
var meta_panel: Panel
var meta_info: Label
var meta_buttons: Array[Button] = []
var expedition_button: Button
var meta_message := "Выберите «Начать экспедицию». После каждого рана доступно одно улучшение."
var meta_save_error := ""
var battle_overlay: ColorRect
var battle_canvas: Node2D
var battle_status: Label
var battle_result: Label
var building_workers: Dictionary = {}
var staffing_overlay: ColorRect
var staffing_info: Label
var staffing_add: Button
var staffing_remove: Button
var hospital_heal_button: Button
var kitchen_pickup_button: Button
var selected_building := -1
const CLASS_NAMES := ["Стрелок", "Воин", "Учёный", "Повар"]
const CLASS_COLORS := [Color(0.3, 0.72, 1.0), Color(0.9, 0.7, 0.3), Color(0.7, 0.45, 1.0), Color(0.95, 0.95, 0.85)]
var recruitment_panel: Panel
var recruitment_info: Label
var recruitment_counts: Array[SpinBox] = []
var recruitment_launch: Button
var recruitment_updating := false
var staffing_class: OptionButton
var projectiles: Array[Dictionary] = []
var laser_beams: Array[Dictionary] = []
var boss_unit: Dictionary = {}
var boss_pulse_time := 0.0
var boss_pulse_position := Vector2.ZERO
var revealed_cells: Dictionary = {}
var scout_button: Button
var scout_info: Label
var money := 0
var run_money := 0
var carried_artifacts := 0
var stored_artifacts := 0
var purchased_building_slots: Array[int] = [0, 0, 0, 0]
var shop_buttons: Array[Button] = []
var sell_artifacts_button: Button
var event_confirm_button: Button
var artifact_use_button: Button
var artifact_keep_button: Button
var cell_stocks: Dictionary = {}
var convoys: Array[Dictionary] = []
var convoy_markers: Array[Label] = []
var logistics_button: Button
var logistics_overlay: ColorRect
var logistics_info: Label
var logistics_job: OptionButton
var kitchen_destinations: Array[Vector2i] = []
var pending_ambushes: Array[Dictionary] = []
var transport_combat := false
var pending_expedition_end: int = -1
var attacked_convoy: Dictionary = {}
var transport_snapshot: Dictionary = {}
var transport_notice: ColorRect
var transport_notice_text: Label
var logistics_message: Label
var cargo_inputs: Array[SpinBox] = []
var convoy_inputs: Array[SpinBox] = []
var send_convoy_button: Button
var pickup_button: Button
var deposit_button: Button

func _ready() -> void:
	map_columns = maxi(1, map_columns)
	map_rows = maxi(1, map_rows)
	start_cell = Vector2i(clampi(start_cell.x, 1, map_columns), clampi(start_cell.y, 1, map_rows))
	goal_cell = Vector2i(clampi(goal_cell.x, 1, map_columns), clampi(goal_cell.y, 1, map_rows))
	map_position = start_cell
	visited.append(start_cell)
	expedition_size = initial_people
	supplies = initial_supplies
	expedition_complete = start_cell == goal_cell
	rng.randomize()
	var title := Label.new()
	title.position = Vector2(30, 18)
	title.text = "SHROOMS / СПУСК"
	title.add_theme_font_size_override("font_size", 26)
	add_child(title)
	status = Label.new()
	status.add_theme_font_size_override("font_size", 14)
	status.position = Vector2(30, 60)
	add_child(status)
	result = Label.new()
	result.position = Vector2(30, 670)
	result.text = "Синий — стрелок · золотой — воин · фиолетовый — учёный · белый — повар. Грибы: зелёный — обычный, красный — тяжёлый, розовый — стрелок, оранжевый — быстрый."
	add_child(result)
	choices = Panel.new()
	choices.position = Vector2(240, 245)
	choices.size = Vector2(620, 225)
	add_child(choices)
	choice_title = Label.new()
	choice_title.position = Vector2(25, 20)
	choice_title.size = Vector2(570, 60)
	choice_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	choices.add_child(choice_title)
	var labels := ["Новые люди +%d" % reward_people, "Больше грибов +" + str(snappedf(reward_enemy_growth * 100.0, 0.01)) + "%", "Сила атаки +" + str(snappedf(reward_attack_growth * 100.0, 0.01)) + "%"]
	for i in range(3):
		var button := Button.new()
		button.position = Vector2(20 + i * 200, 105)
		button.size = Vector2(180, 65)
		button.text = labels[i]
		button.pressed.connect(choose_bonus.bind(i))
		choices.add_child(button)
	build_map()
	build_battle_overlay()
	build_construction_menu()
	build_event_popup()
	build_staffing_menu()
	build_logistics_menu()
	build_meta_screen()
	build_recruitment_screen()
	build_transport_notice()
	load_meta_progress()
	show_meta_screen()

func build_meta_screen() -> void:
	meta_panel = Panel.new()
	meta_panel.position = Vector2(140, 95)
	meta_panel.size = Vector2(820, 565)
	add_child(meta_panel)
	meta_info = Label.new()
	meta_info.position = Vector2(25, 20)
	meta_info.size = Vector2(770, 175)
	meta_info.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	meta_info.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	meta_info.add_theme_font_size_override("font_size", 16)
	meta_panel.add_child(meta_info)
	for i in range(3):
		var button := Button.new()
		button.position = Vector2(20 + i * 260, 200)
		button.size = Vector2(250, 70)
		button.pressed.connect(choose_meta_upgrade.bind(i))
		meta_panel.add_child(button)
		meta_buttons.append(button)
	var reset := Button.new()
	reset.position = Vector2(30, 465)
	reset.size = Vector2(310, 65)
	reset.text = "Сбросить прогрессию"
	reset.pressed.connect(reset_meta_progress)
	meta_panel.add_child(reset)
	expedition_button = Button.new()
	expedition_button.position = Vector2(380, 465)
	expedition_button.size = Vector2(410, 65)
	expedition_button.text = "Начать экспедицию"
	expedition_button.pressed.connect(open_recruitment)
	meta_panel.add_child(expedition_button)
	for building_type in range(BUILDING_NAMES.size()):
		var buy := Button.new()
		buy.position = Vector2(20 + building_type * 200, 290)
		buy.size = Vector2(190, 70)
		buy.pressed.connect(buy_building_slot.bind(building_type))
		meta_panel.add_child(buy)
		shop_buttons.append(buy)
	sell_artifacts_button = Button.new()
	sell_artifacts_button.position = Vector2(30, 380)
	sell_artifacts_button.size = Vector2(760, 55)
	sell_artifacts_button.pressed.connect(sell_artifacts)
	meta_panel.add_child(sell_artifacts_button)

func show_meta_screen() -> void:
	on_map = false
	finished = true
	awaiting_choice = false
	pending_event = -1
	units.clear()
	map_panel.hide()
	battle_overlay.hide()
	choices.hide()
	construction_overlay.hide()
	staffing_overlay.hide()
	logistics_overlay.hide()
	event_overlay.hide()
	status.hide()
	result.hide()
	recruitment_panel.hide()
	meta_panel.show()
	update_meta_screen()
	battle_canvas.queue_redraw()

func update_meta_screen() -> void:
	var starting_attack := pow(1.0 + meta_attack_growth, meta_attack_level)
	var starting_mushrooms := pow(1.0 + meta_enemy_growth, meta_enemy_level)
	meta_info.text = "ЭКСПЕДИЦИЯ / ПОСТОЯННЫЕ УЛУЧШЕНИЯ\n%s\nНа старте: %d людей · Атака ×%.2f · Грибы ×%.2f\nПрипасы: %d\n%s" % [meta_message, initial_people + meta_people_level * meta_people_bonus, starting_attack, starting_mushrooms, initial_supplies, "Выберите одно улучшение." if meta_upgrade_available else "Следующее улучшение — после завершения экспедиции."]
	meta_info.text += "\nДеньги: %d · Вынесенных артефактов: %d" % [money, stored_artifacts]
	for kind in range(shop_buttons.size()):
		shop_buttons[kind].text = "%s: лимит %d\nКупить +1 за %d монет" % [BUILDING_NAMES[kind], building_limit(kind), building_price(kind)]
		shop_buttons[kind].disabled = money < building_price(kind)
	sell_artifacts_button.text = "Продать артефакты: %d × %d = %d монет" % [stored_artifacts, artifact_sale_price, stored_artifacts * artifact_sale_price]
	sell_artifacts_button.disabled = stored_artifacts == 0
	if not meta_save_error.is_empty():
		meta_info.text += "\n" + meta_save_error
	meta_buttons[0].text = "+%d людей на старте\nУровень: %d" % [meta_people_bonus, meta_people_level]
	meta_buttons[1].text = "+%s%% атаки на старте\nУровень: %d" % [str(snappedf(meta_attack_growth * 100.0, 0.01)), meta_attack_level]
	meta_buttons[2].text = "+%s%% грибов на старте\nУровень: %d" % [str(snappedf(meta_enemy_growth * 100.0, 0.01)), meta_enemy_level]
	for button in meta_buttons:
		button.disabled = not meta_upgrade_available
	expedition_button.disabled = meta_upgrade_available

func load_meta_progress() -> void:
	var config := ConfigFile.new()
	if config.load(META_SAVE) != OK:
		return
	meta_people_level = maxi(0, int(config.get_value("meta", "people", 0)))
	meta_attack_level = maxi(0, int(config.get_value("meta", "attack", 0)))
	meta_enemy_level = maxi(0, int(config.get_value("meta", "enemies", 0)))
	meta_upgrade_available = bool(config.get_value("meta", "upgrade_available", false))
	meta_message = str(config.get_value("meta", "message", meta_message))
	money = maxi(0, int(config.get_value("economy", "money", 0)))
	stored_artifacts = maxi(0, int(config.get_value("economy", "artifacts", 0)))
	for kind in range(BUILDING_NAMES.size()):
		purchased_building_slots[kind] = maxi(0, int(config.get_value("economy", "building_%d" % kind, 0)))

func save_meta_progress() -> void:
	var config := ConfigFile.new()
	config.set_value("meta", "people", meta_people_level)
	config.set_value("meta", "attack", meta_attack_level)
	config.set_value("meta", "enemies", meta_enemy_level)
	config.set_value("meta", "upgrade_available", meta_upgrade_available)
	config.set_value("meta", "message", meta_message)
	config.set_value("economy", "money", money)
	config.set_value("economy", "artifacts", stored_artifacts)
	for kind in range(BUILDING_NAMES.size()):
		config.set_value("economy", "building_%d" % kind, purchased_building_slots[kind])
	var error := config.save(META_SAVE)
	meta_save_error = "" if error == OK else "Не удалось сохранить прогрессию: %s" % error_string(error)

func choose_meta_upgrade(index: int) -> void:
	if run_active or not meta_upgrade_available or not meta_panel.visible:
		return
	match index:
		0:
			meta_people_level += 1
		1:
			meta_attack_level += 1
		2:
			meta_enemy_level += 1
		_:
			return
	meta_upgrade_available = false
	meta_message = "Улучшение выбрано. Готовы к новой экспедиции!"
	save_meta_progress()
	update_meta_screen()

func reset_meta_progress() -> void:
	if run_active or not meta_panel.visible:
		return
	meta_people_level = 0
	meta_attack_level = 0
	meta_enemy_level = 0
	meta_upgrade_available = false
	money = 0
	stored_artifacts = 0
	purchased_building_slots = [0, 0, 0, 0]
	meta_message = "Прогрессия сброшена. Новая экспедиция начнётся с базовыми параметрами."
	save_meta_progress()
	update_meta_screen()

func start_expedition() -> void:
	if not recruitment_panel.visible or recruitment_total() != initial_people + meta_people_level * meta_people_bonus:
		return
	if run_active or meta_upgrade_available:
		return
	meta_panel.hide()
	recruitment_panel.hide()
	status.show()
	result.show()
	run_active = true
	run_money = 0
	carried_artifacts = 0
	map_position = start_cell
	visited.clear()
	revealed_cells.clear()
	visited.append(start_cell)
	buildings.clear()
	building_workers.clear()
	cell_stocks.clear()
	convoys.clear()
	pending_ambushes.clear()
	cell_enemy_variation.clear()
	pending_expedition_end = -1
	selected_building = -1
	people.clear()
	units.clear()
	battle_number = 0
	step_number = 0
	last_starved_deaths = 0
	elapsed = 0.0
	pending_event = -1
	awaiting_choice = false
	supplies = mini(initial_supplies, (initial_people + meta_people_level * meta_people_bonus) * carry_capacity_per_person)
	stock_at(start_cell).food = maxi(0, initial_supplies - supplies)
	attack_multiplier = pow(1.0 + meta_attack_growth, meta_attack_level)
	enemy_multiplier = pow(1.0 + meta_enemy_growth, meta_enemy_level)
	for class_id in range(CLASS_NAMES.size()):
		for i in range(int(recruitment_counts[class_id].value)):
			people.append(new_person(class_id))
	expedition_size = people.size()
	expedition_complete = start_cell == goal_cell
	generate_cell_events()
	show_map()

func finish_expedition(victory: bool) -> void:
	if transport_combat or not pending_ambushes.is_empty():
		pending_expedition_end = 1 if victory else 0
		return
	if not run_active:
		return
	run_active = false
	meta_upgrade_available = true
	meta_message = "%s · Этаж: %d · Ходов: %d · Боёв: %d · Выживших: %d" % ["ПОБЕДА!" if victory else "ПОРАЖЕНИЕ", map_position.y, step_number, battle_number, people.size()]
	for convoy in convoys:
		complete_convoy(convoy)
	convoys.clear()
	if victory:
		stored_artifacts += carried_artifacts
		money += run_money
	meta_message += "\nМонет при себе: %d · Артефактов вынесено: %d · Потеряно: %d" % [run_money, carried_artifacts if victory else 0, 0 if victory else carried_artifacts]
	carried_artifacts = 0
	run_money = 0
	save_meta_progress()
	show_meta_screen()

func start_battle() -> void:
	show_map()
	on_map = false
	status.hide()
	result.hide()
	battle_overlay.show()
	units.clear()
	projectiles.clear()
	laser_beams.clear()
	boss_unit = {}
	boss_pulse_time = 0.0
	elapsed = 0.0
	finished = false
	awaiting_choice = false
	choices.hide()
	expedition_size = people.size()
	starting_humans = expedition_size
	starting_enemies = enemies_at(map_position) - (1 if map_position == goal_cell else 0)
	var formation_order := [1, 0, 3, 2]
	for rank in range(formation_order.size()):
		var class_id: int = formation_order[rank]
		var group: Array[Dictionary] = []
		for person in people:
			if person.class_id == class_id:
				group.append(person)
		var rows := ceili(group.size() / 3.0)
		for i in range(group.size()):
			var row := floori(i / 3.0)
			var y := 385.0 if rows <= 1 else 150.0 + row * 470.0 / (rows - 1)
			var pos := Vector2(420.0 - rank * 90.0 - (i % 3) * 20.0, y)
			spawn_unit(0, pos)
			var unit: Dictionary = units[-1]
			unit.person = group[i]
			unit.hp *= class_hp_multiplier(class_id)
			unit.max_hp = unit.hp
			unit.hp = unit.max_hp * clampf(float(group[i].get("health_fraction", 1.0)), 0.0, 1.0)
			unit.damage *= class_damage_multiplier(class_id)
			unit.attack_range = shooter_range if class_id == 0 else (shooter_range * scientist_range_multiplier if class_id == 2 else 0.0)
			unit.damage *= maxf(0.0, 1.0 - hunger_damage_loss * float(group[i].hunger))
	spawn_enemy_group(starting_enemies)
	battle_result.text = "Синий — стрелок · золотой — воин · фиолетовый — учёный · белый — повар. Грибы: зелёный — обычный, красный — тяжёлый, розовый — стрелок, оранжевый — быстрый."
	if map_position == goal_cell:
		spawn_unit(5, Vector2(790, 385))
		boss_unit = units[-1]
		starting_enemies += 1
		battle_result.text = "БОСС: ГРИБНОЙ ПАТРИАРХ. Его удар поражает всех экспедиторов рядом с ним!"
	update_status(starting_humans, starting_enemies)
	battle_canvas.queue_redraw()

func update_status(humans: int, enemies: int) -> void:
	battle_status.text = "БОЙ %d     ЛЮДИ %d/%d     ВРАГИ %d/%d     %.1f сек." % [battle_number, humans, starting_humans, enemies, starting_enemies, elapsed]
	if transport_combat:
		battle_status.text = "ЗАСАДА · ЭТАЖ %d · НОСИЛЬЩИКИ %d/%d · ВРАГИ %d/%d" % [map_position.y, humans, starting_humans, enemies, starting_enemies]
	if not boss_unit.is_empty():
		battle_status.text += "     БОСС %.0f/%.0f HP" % [boss_unit.hp, boss_unit.max_hp]
	battle_status.tooltip_text = "Атака ×%.2f · Голодных %d · Еды %d" % [attack_multiplier * camp_multiplier(), hungry_count(), supplies]

func choose_bonus(index: int) -> void:
	if not awaiting_choice:
		return
	awaiting_choice = false
	match index:
		0:
			for i in range(reward_people):
				people.append(new_person(rng.randi_range(0, 3)))
			expedition_size = people.size()
		1:
			enemy_multiplier *= 1.0 + reward_enemy_growth
		2:
			attack_multiplier *= 1.0 + reward_attack_growth
	choices.hide()
	if not visited.has(map_position):
		visited.append(map_position)
	if map_position == goal_cell:
		expedition_complete = true
	show_map()

func build_battle_overlay() -> void:
	battle_overlay = ColorRect.new()
	battle_overlay.size = Vector2(1100, 720)
	battle_overlay.color = Color(0, 0, 0, 0.7)
	battle_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(battle_overlay)
	battle_canvas = Node2D.new()
	var ratio := clampf(battle_window_scale, 0.5, 0.95)
	battle_canvas.position = Vector2(1100, 720) * (1.0 - ratio) * 0.5
	battle_canvas.scale = Vector2.ONE * ratio
	battle_overlay.add_child(battle_canvas)
	battle_canvas.draw.connect(draw_battle)
	var heading := Label.new()
	heading.position = Vector2(30, 15)
	heading.text = "БОЙ ЭКСПЕДИЦИИ"
	heading.add_theme_font_size_override("font_size", 24)
	battle_canvas.add_child(heading)
	battle_status = Label.new()
	battle_status.add_theme_font_size_override("font_size", 14)
	battle_status.position = Vector2(30, 55)
	battle_canvas.add_child(battle_status)
	battle_result = Label.new()
	battle_result.position = Vector2(30, 665)
	battle_result.size = Vector2(1040, 45)
	battle_result.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	battle_canvas.add_child(battle_result)
	choices.reparent(battle_canvas, false)
	battle_overlay.hide()

func build_map() -> void:
	map_panel = Control.new()
	map_panel.position = Vector2(340, 125)
	var tile := Vector2(minf(84.0, 960.0 / map_columns), minf(53.0, 530.0 / map_rows))
	map_panel.position.x = (1100.0 - tile.x * map_columns) / 2.0
	add_child(map_panel)
	scout_button = Button.new()
	scout_button.position = Vector2(30 - map_panel.position.x, 20)
	scout_button.size = Vector2(240, 60)
	scout_button.text = "Разведка · 1 ход"
	scout_button.pressed.connect(scout_neighbors)
	map_panel.add_child(scout_button)
	scout_info = Label.new()
	scout_info.position = Vector2(30 - map_panel.position.x, 95)
	scout_info.size = Vector2(240, 220)
	scout_info.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	map_panel.add_child(scout_info)
	scout_info.hide()
	logistics_button = Button.new()
	logistics_button.position = Vector2(30 - map_panel.position.x, 95)
	logistics_button.size = Vector2(240, 60)
	logistics_button.text = "Грузы и снабжение"
	logistics_button.pressed.connect(open_logistics_menu)
	map_panel.add_child(logistics_button)
	for row in range(1, map_rows + 1):
		for column in range(1, map_columns + 1):
			var cell := Vector2i(column, row)
			var button := Button.new()
			button.position = Vector2((column - 1) * tile.x, (row - 1) * tile.y)
			button.size = tile - Vector2(6, 4)
			button.pressed.connect(move_on_map.bind(cell))
			map_panel.add_child(button)
			map_buttons.append(button)
			var marker := Label.new()
			marker.position = Vector2(maxf(0, button.size.x - 26), 1)
			marker.size = Vector2(25, 22)
			marker.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			marker.add_theme_font_size_override("font_size", 16)
			marker.add_theme_color_override("font_color", Color(0.3, 1.0, 1.0))
			marker.add_theme_color_override("font_outline_color", Color(0.03, 0.08, 0.12))
			marker.add_theme_constant_override("outline_size", 4)
			marker.mouse_filter = Control.MOUSE_FILTER_IGNORE
			button.add_child(marker)
			marker.hide()
			convoy_markers.append(marker)

func show_map() -> void:
	if run_active and (expedition_complete or people.is_empty()):
		finish_expedition(expedition_complete and not people.is_empty())
		return
	on_map = true
	finished = true
	units.clear()
	choices.hide()
	construction_overlay.hide()
	staffing_overlay.hide()
	logistics_overlay.hide()
	event_overlay.hide()
	battle_overlay.hide()
	status.show()
	result.show()
	map_panel.show()
	var turns_of_food := floori(float(supplies) / maxi(1, people.size() * supplies_per_person))
	status.text = "ЭТАЖ %d/%d    ЛЮДИ %d    ЕДА %d (~%d ход.)    ГРУЗ %d/%d    МОНЕТЫ %d    АРТЕФАКТЫ %d" % [map_position.y, map_rows, people.size(), supplies, turns_of_food, cargo_weight(supplies, run_money, carried_artifacts), cargo_capacity(), run_money, carried_artifacts]
	status.tooltip_text = "Ход %d · Работников %d · Голодных %d · Караванов %d · Деньги на базе %d\nАтака ×%.2f · Грибов на этаже %d · Раненых %d" % [step_number, worker_count(), hungry_count(), convoys.size(), money, attack_multiplier * camp_multiplier(), enemies_at(map_position), wounded_count()]
	result.text = "Клик по своей клетке — здание. «Грузы» — запасы и отправка добычи наверх."
	if expedition_complete:
		result.text = "ПОБЕДА! Экспедиция достигла цели. Завершено боёв: %d. Выжило людей: %d." % [battle_number, expedition_size]
	if people.is_empty():
		result.text = "ПОРАЖЕНИЕ: все люди погибли от голода. Перезапустите сцену (F6)."
	for row in range(1, map_rows + 1):
		for column in range(1, map_columns + 1):
			var cell := Vector2i(column, row)
			var button: Button = map_buttons[(row - 1) * map_columns + column - 1]
			var difference := cell - map_position
			var adjacent := absi(difference.x) + absi(difference.y) == 1
			button.disabled = expedition_complete or people.is_empty() or (not adjacent and cell != map_position)
			button.text = "XXX"
			button.tooltip_text = "Неизвестная клетка. Разведка раскрывает соседние клетки."
			if revealed_cells.has(cell):
				if cell_events.has(cell):
					button.text = "Ивент"
					button.tooltip_text = event_description(int(cell_events[cell])) if bool(revealed_cells[cell]) else "Событие. Учёный в отряде позволяет узнать эффект."
				else:
					button.text = "Бой"
					button.tooltip_text = "Бой. Учёный в отряде позволяет узнать число врагов."
					if bool(revealed_cells[cell]):
						button.text += "\n%d" % enemies_at(cell)
						button.tooltip_text = "Грибов: %d. Состав: обычные, тяжёлые, стрелки и быстрые." % enemies_at(cell)
						if cell == goal_cell:
							button.tooltip_text += "\nБосс: %.0f здоровья · %.0f урона по области." % [boss_hp, boss_damage]
			button.modulate = Color(0.55, 0.6, 0.65)
			if visited.has(cell):
				button.text = ""
				button.tooltip_text = "Пройденная клетка: без боя и события."
			if adjacent:
				if not visited.has(cell):
					if not button.text.contains("\n"):
						button.text += " →"
				button.modulate = Color(0.5, 1.0, 0.55)
			if visited.has(cell) and cell_stocks.has(cell):
				var stock: Dictionary = cell_stocks[cell]
				if stock.food + stock.coins + stock.artifacts > 0:
					button.text = "Груз"
					button.tooltip_text = "Местный склад: еда %d · монеты %d · артефакты %d" % [stock.food, stock.coins, stock.artifacts]
			if buildings.has(cell):
				var markers := PackedStringArray()
				var names := PackedStringArray()
				for building_type in buildings[cell]:
					markers.append(BUILDING_MARKERS[building_type])
					names.append(BUILDING_NAMES[building_type])
				button.text = " / ".join(markers)
				button.tooltip_text += "\n" + "\n".join(names)
				if not adjacent:
					button.modulate = Color(0.75, 0.65, 1.0)
			if cell == goal_cell:
				button.text = "БОСС" + (" →" if adjacent and not expedition_complete else "")
				button.modulate = Color(1.0, 0.85, 0.25)
			if cell == map_position:
				button.text = "ВЫ ЗДЕСЬ" + ("\n" + button.text if buildings.has(cell) else "")
				button.modulate = Color(0.4, 0.8, 1.0)
	update_convoy_markers()
	scout_button.disabled = not run_active or scouting_targets().is_empty()
	scout_button.tooltip_text = "Разведка раскрывает тип соседних клеток.\n\nУчёный в отряде дополнительно раскрывает число грибов и эффект события (наведите на клетку).\n\nРасход отряда: %d еды. Работники питаются из местных складов." % [people.size() * supplies_per_person]
	battle_canvas.queue_redraw()

func move_on_map(cell: Vector2i) -> void:
	if not on_map or expedition_complete or people.is_empty() or pending_event >= 0:
		return
	if construction_overlay.visible or staffing_overlay.visible or logistics_overlay.visible or pending_event >= 0:
		return
	if cell == map_position:
		if buildings.has(cell) and not buildings[cell].is_empty():
			open_staffing_menu(int(buildings[cell][0]))
		else:
			open_construction_menu()
		return
	if cell.x < 1 or cell.x > map_columns or cell.y < 1 or cell.y > map_rows:
		return
	var difference := cell - map_position
	if absi(difference.x) + absi(difference.y) != 1:
		return
	if cargo_weight(supplies, run_money, carried_artifacts) > cargo_capacity():
		result.text = "Перегруз! Оставьте часть груза через меню «Грузы»."
		return
	map_position = cell
	consume_supplies()
	if people.is_empty() or visited.has(cell):
		show_map()
		return
	if cell_events.has(cell):
		open_cell_event(int(cell_events[cell]))
		return
	battle_number += 1
	start_battle()

func enemies_at(cell: Vector2i) -> int:
	if not cell_enemy_variation.has(cell):
		cell_enemy_variation[cell] = rng.randf_range(1.0 - enemy_count_variation, 1.0 + enemy_count_variation)
	var count := random_enemy_count(cell.y, float(cell_enemy_variation[cell]))
	return count + (1 if cell == goal_cell else 0)

func scouting_targets() -> Array[Vector2i]:
	var targets: Array[Vector2i] = []
	var detailed := class_count(people, 2) > 0
	for direction in [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]:
		var cell: Vector2i = map_position + direction
		if cell.x < 1 or cell.x > map_columns or cell.y < 1 or cell.y > map_rows or visited.has(cell):
			continue
		if not revealed_cells.has(cell) or (detailed and not bool(revealed_cells[cell])):
			targets.append(cell)
	return targets

func scout_neighbors() -> void:
	if not run_active or not on_map or pending_event >= 0 or construction_overlay.visible or staffing_overlay.visible or logistics_overlay.visible:
		return
	var targets := scouting_targets()
	if targets.is_empty():
		return
	consume_supplies()
	if people.is_empty():
		show_map()
		return
	var detailed := class_count(people, 2) > 0
	for cell in targets:
		revealed_cells[cell] = detailed or bool(revealed_cells.get(cell, false))
	show_map()
	result.text = "Разведано клеток: %d. %s Прошёл 1 ход." % [targets.size(), "Учёные раскрыли подробности — наведите на клетку." if detailed else "Раскрыты бои и события."]

func generate_cell_events() -> void:
	var cells: Array[Vector2i] = []
	for row in range(1, map_rows + 1):
		for column in range(1, map_columns + 1):
			var cell := Vector2i(column, row)
			if cell != start_cell and cell != goal_cell:
				cells.append(cell)
	for i in range(cells.size() - 1, 0, -1):
		var other := rng.randi_range(0, i)
		var temporary: Vector2i = cells[i]
		cells[i] = cells[other]
		cells[other] = temporary
	cell_events.clear()
	for i in range(floori(cells.size() * 0.25)):
		cell_events[cells[i]] = rng.randi_range(0, 5)

func build_event_popup() -> void:
	event_overlay = ColorRect.new()
	event_overlay.size = Vector2(1100, 720)
	event_overlay.color = Color(0, 0, 0, 0.75)
	event_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(event_overlay)
	var panel := Panel.new()
	panel.position = Vector2(300, 230)
	panel.size = Vector2(500, 250)
	event_overlay.add_child(panel)
	event_label = Label.new()
	event_label.position = Vector2(20, 25)
	event_label.size = Vector2(460, 125)
	event_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	event_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	event_label.add_theme_font_size_override("font_size", 22)
	panel.add_child(event_label)
	var confirm := Button.new()
	confirm.position = Vector2(150, 175)
	confirm.size = Vector2(200, 50)
	confirm.text = "Подтвердить"
	confirm.pressed.connect(confirm_cell_event)
	panel.add_child(confirm)
	event_confirm_button = confirm
	artifact_use_button = Button.new()
	artifact_use_button.position = Vector2(20, 175)
	artifact_use_button.size = Vector2(225, 50)
	artifact_use_button.pressed.connect(resolve_artifact.bind(true))
	panel.add_child(artifact_use_button)
	artifact_keep_button = Button.new()
	artifact_keep_button.position = Vector2(255, 175)
	artifact_keep_button.size = Vector2(225, 50)
	artifact_keep_button.text = "Забрать с собой"
	artifact_keep_button.pressed.connect(resolve_artifact.bind(false))
	panel.add_child(artifact_keep_button)
	artifact_use_button.hide()
	artifact_keep_button.hide()
	event_overlay.hide()

func event_description(event_type: int) -> String:
	match event_type:
		0:
			return "Сила атаки: +" + str(snappedf(event_attack_growth * 100.0, 0.01)) + "%"
		1:
			return "Новые люди: +%d" % event_new_people
		2:
			return "Количество грибов: +" + str(snappedf(event_enemy_growth * 100.0, 0.01)) + "%"
		3:
			return "Количество грибов: ×" + str(event_enemy_multiplier)
		4:
			return "Сила атаки: ×" + str(event_attack_multiplier)
		5:
			return "Артефакт: усилить атаку или вынести для продажи."
	return ""

func open_cell_event(event_type: int) -> void:
	show_map()
	pending_event = event_type
	event_label.text = "СОБЫТИЕ\n\n" + event_description(event_type)
	event_confirm_button.visible = event_type != 5
	artifact_use_button.visible = event_type == 5
	artifact_keep_button.visible = event_type == 5
	artifact_use_button.text = "Атака +%.0f%%" % (artifact_attack_growth * 100.0)
	if event_type == 5:
		event_label.text = "НАЙДЕН АРТЕФАКТ\nИспользовать сейчас или вынести?\nПродажа после победы: %d монет" % artifact_sale_price
	event_overlay.show()

func confirm_cell_event() -> void:
	if pending_event < 0 or pending_event == 5 or not event_overlay.visible:
		return
	var description := event_description(pending_event)
	match pending_event:
		0:
			attack_multiplier *= 1.0 + event_attack_growth
		1:
			for i in range(event_new_people):
				people.append(new_person(rng.randi_range(0, 3)))
		2:
			enemy_multiplier *= 1.0 + event_enemy_growth
		3:
			enemy_multiplier *= event_enemy_multiplier
		4:
			attack_multiplier *= event_attack_multiplier
	pending_event = -1
	expedition_size = people.size()
	if not visited.has(map_position):
		visited.append(map_position)
	show_map()
	result.text = "Событие: %s. Эффект применён. Выберите следующий шаг." % description

func build_construction_menu() -> void:
	construction_overlay = ColorRect.new()
	construction_overlay.position = Vector2.ZERO
	construction_overlay.size = Vector2(1100, 720)
	construction_overlay.color = Color(0, 0, 0, 0.75)
	construction_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(construction_overlay)
	var panel := Panel.new()
	panel.position = Vector2(300, 165)
	panel.size = Vector2(500, 470)
	construction_overlay.add_child(panel)
	construction_title = Label.new()
	construction_title.position = Vector2(20, 15)
	construction_title.size = Vector2(460, 80)
	construction_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	panel.add_child(construction_title)
	for i in range(BUILDING_NAMES.size()):
		var button := Button.new()
		button.position = Vector2(30, 105 + i * 65)
		button.size = Vector2(440, 55)
		button.pressed.connect(construct_building.bind(i))
		panel.add_child(button)
		construction_buttons.append(button)
	var close := Button.new()
	close.position = Vector2(150, 390)
	close.size = Vector2(200, 50)
	close.text = "Закрыть"
	close.pressed.connect(close_construction_menu)
	panel.add_child(close)
	construction_overlay.hide()

func open_construction_menu() -> void:
	if not on_map or expedition_complete or people.is_empty() or pending_event >= 0:
		return
	construction_title.text = "ПОСТРОЙКИ\nСтроительство: 1 ход · Расход отряда: %d еды\nДоступно припасов: %d" % [people.size() * supplies_per_person, supplies]
	for i in range(construction_buttons.size()):
		var already_built: bool = buildings.has(map_position) and buildings[map_position].has(i)
		construction_buttons[i].disabled = (buildings.has(map_position) and not already_built) or (not already_built and used_building_slots(i) >= building_limit(i))
		construction_buttons[i].text = BUILDING_NAMES[i] + (" — работники %d/%d" % [staff_at(map_position, i).size(), building_worker_capacity] if already_built else (" — сначала снесите здание" if buildings.has(map_position) else " — доступно %d/%d" % [maxi(0, building_limit(i) - used_building_slots(i)), building_limit(i)]))
	construction_overlay.show()

func close_construction_menu() -> void:
	construction_overlay.hide()
	staffing_overlay.hide()

func construct_building(building_type: int) -> void:
	if not on_map or not construction_overlay.visible or expedition_complete or people.is_empty():
		return
	if building_type < 0 or building_type >= BUILDING_NAMES.size():
		return
	if buildings.has(map_position) and buildings[map_position].has(building_type):
		open_staffing_menu(building_type)
		return
	if buildings.has(map_position) or used_building_slots(building_type) >= building_limit(building_type):
		return
	consume_supplies()
	if not buildings.has(map_position):
		buildings[map_position] = []
	buildings[map_position].append(building_type)
	staff_at(map_position, building_type)
	show_map()
	if not people.is_empty():
		result.text = "Построено: %s. Прошёл 1 ход. Постройка остаётся на этой клетке." % BUILDING_NAMES[building_type]

func floor_enemy_multiplier(floor_number: int) -> float:
	var depth := float(clampi(floor_number, 1, map_rows) - 1) / maxf(map_rows - 1, 1)
	return lerpf(1.0, last_floor_enemy_multiplier, depth)

func hungry_count() -> int:
	var count := 0
	for cell in building_workers:
		for kind in building_workers[cell]:
			for worker in building_workers[cell][kind]:
				if worker.hunger > 0:
					count += 1
	for person in people:
		if person.hunger > 0:
			count += 1
	return count

func consume_supplies() -> void:
	step_number += 1
	last_starved_deaths = 0
	for cell in building_workers:
		for kind in building_workers[cell]:
			var stock := stock_at(cell)
			if kind == 1:
				stock.food += roundi(staff_power(building_workers[cell][kind], 1) * kitchen_food_per_worker)
			var survivors: Array[Dictionary] = []
			for person in building_workers[cell][kind]:
				if stock.food >= supplies_per_person:
					stock.food -= supplies_per_person
					person.hunger = 0
				else:
					stock.food = 0
					person.hunger += 1
				if person.hunger >= hunger_death_steps:
					last_starved_deaths += 1
				else:
					survivors.append(person)
			building_workers[cell][kind] = survivors
	advance_convoys()
	people = feed_people(people)
	expedition_size = people.size()

func feed_people(group: Array) -> Array[Dictionary]:
	var survivors: Array[Dictionary] = []
	for person in group:
		if supplies >= supplies_per_person:
			supplies -= supplies_per_person
			person.hunger = 0
		else:
			supplies = 0
			person.hunger += 1
		if person.hunger >= hunger_death_steps:
			last_starved_deaths += 1
		else:
			survivors.append(person)
	return survivors

func staff_at(cell: Vector2i, building_type: int) -> Array:
	if not building_workers.has(cell):
		building_workers[cell] = {}
	if not building_workers[cell].has(building_type):
		building_workers[cell][building_type] = []
	return building_workers[cell][building_type]

func worker_count(building_type: int = -1) -> int:
	var total := 0
	for cell in building_workers:
		for kind in building_workers[cell]:
			if building_type == -1 or kind == building_type:
				total += building_workers[cell][kind].size()
	return total

func camp_multiplier() -> float:
	return 1.0 + workforce_power(0) * camp_attack_per_worker

func laboratory_multiplier() -> float:
	var reduction := minf(workforce_power(2) * lab_reduction_per_worker, clampf(lab_max_reduction, 0.0, 0.95))
	return 1.0 - reduction

func build_staffing_menu() -> void:
	staffing_overlay = ColorRect.new()
	staffing_overlay.size = Vector2(1100, 720)
	staffing_overlay.color = Color(0, 0, 0, 0.75)
	staffing_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(staffing_overlay)
	var panel := Panel.new()
	panel.position = Vector2(280, 175)
	panel.size = Vector2(540, 490)
	staffing_overlay.add_child(panel)
	staffing_info = Label.new()
	staffing_info.position = Vector2(20, 20)
	staffing_info.size = Vector2(500, 180)
	staffing_info.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	staffing_info.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	panel.add_child(staffing_info)
	staffing_class = OptionButton.new()
	staffing_class.position = Vector2(30, 210)
	staffing_class.size = Vector2(480, 45)
	for class_id in range(CLASS_NAMES.size()):
		staffing_class.add_item(CLASS_NAMES[class_id], class_id)
	staffing_class.item_selected.connect(on_staffing_class_selected)
	panel.add_child(staffing_class)
	staffing_remove = Button.new()
	staffing_remove.position = Vector2(30, 270)
	staffing_remove.size = Vector2(230, 55)
	staffing_remove.text = "Забрать человека −1"
	staffing_remove.pressed.connect(change_staff.bind(-1))
	panel.add_child(staffing_remove)
	staffing_add = Button.new()
	staffing_add.position = Vector2(280, 270)
	staffing_add.size = Vector2(230, 55)
	staffing_add.text = "Назначить человека +1"
	staffing_add.pressed.connect(change_staff.bind(1))
	panel.add_child(staffing_add)
	var close := Button.new()
	close.position = Vector2(30, 350)
	close.size = Vector2(230, 50)
	close.text = "Готово"
	close.pressed.connect(close_staffing_menu)
	panel.add_child(close)
	var demolish := Button.new()
	demolish.position = Vector2(280, 350)
	demolish.size = Vector2(230, 50)
	demolish.text = "Снести здание — 1 ход"
	demolish.tooltip_text = "Работники вернутся в отряд. Снос тратит один ход и припасы."
	demolish.pressed.connect(demolish_building)
	panel.add_child(demolish)
	hospital_heal_button = Button.new()
	hospital_heal_button.position = Vector2(30, 415)
	hospital_heal_button.size = Vector2(480, 50)
	hospital_heal_button.text = "Вылечить отряд полностью · 1 ход"
	hospital_heal_button.pressed.connect(heal_at_hospital)
	panel.add_child(hospital_heal_button)
	hospital_heal_button.hide()
	kitchen_pickup_button = Button.new()
	kitchen_pickup_button.position = Vector2(30, 415)
	kitchen_pickup_button.size = Vector2(480, 50)
	kitchen_pickup_button.pressed.connect(pickup_kitchen_food)
	panel.add_child(kitchen_pickup_button)
	kitchen_pickup_button.hide()
	staffing_overlay.hide()

func open_staffing_menu(building_type: int) -> void:
	if not on_map or not run_active or not buildings.has(map_position):
		return
	if not buildings[map_position].has(building_type):
		return
	selected_building = building_type
	construction_overlay.hide()
	refresh_staffing_menu()
	staffing_overlay.show()

func refresh_staffing_menu() -> void:
	var staff := staff_at(map_position, selected_building)
	var effect := ""
	match selected_building:
		0:
			effect = "Атака от всех лагерей: ×%.2f\nОбычный работник: +%.0f%% атаки. Учёный эффективнее." % [camp_multiplier(), camp_attack_per_worker * 100.0]
		1:
			effect = "Производство: +%d еды/ход\nНа складе здесь: %d еды" % [roundi(staff_power(staff, 1) * kitchen_food_per_worker), int(stock_at(map_position).food)]
		2:
			effect = "Грибы с учётом всех лабораторий: ×%.2f\nОбычный работник: −%.0f%% грибов. Учёный эффективнее.\nПредел снижения: −%.0f%%." % [laboratory_multiplier(), lab_reduction_per_worker * 100.0, clampf(lab_max_reduction, 0.0, 0.95) * 100.0]
	if selected_building == 3:
		effect = "Полное лечение отряда за один ход.\nЛазарету не нужны работники."
	staffing_info.text = "%s · %d/%d работников\n%s\nЕда на складе: %d · Расход: %d/ход\n\nВыберите класс ниже. Склад — в меню «Грузы»." % [BUILDING_NAMES[selected_building], staff.size(), building_worker_capacity, effect, int(stock_at(map_position).food), staff.size() * supplies_per_person]
	for class_id in range(CLASS_NAMES.size()):
		staffing_class.set_item_text(class_id, "%s · В отряде: %d · Здесь: %d" % [CLASS_NAMES[class_id], class_count(people, class_id), class_count(staff, class_id)])
	var selected_class := staffing_class.get_selected_id()
	staffing_add.disabled = staff.size() >= building_worker_capacity or people.size() <= 1 or class_count(people, selected_class) == 0
	staffing_remove.disabled = class_count(staff, selected_class) == 0
	kitchen_pickup_button.visible = selected_building == 1
	var room := maxi(0, cargo_capacity() - cargo_weight(supplies, run_money, carried_artifacts))
	var food_available := mini(int(stock_at(map_position).food), room)
	kitchen_pickup_button.text = "Забрать еду: +%d" % food_available
	kitchen_pickup_button.disabled = food_available == 0
	kitchen_pickup_button.tooltip_text = "Склад пуст" if int(stock_at(map_position).food) == 0 else ("Рюкзаки заполнены — освободите место через «Грузы»." if room == 0 else "Забрать еду со склада кухни. Дополнительный ход не тратится.")
	hospital_heal_button.visible = selected_building == 3
	hospital_heal_button.disabled = wounded_count() == 0
	if selected_building == 3:
		staffing_info.text = "ПОЛЕВОЙ ЛАЗАРЕТ\nРаненых в отряде: %d / %d\n\nПолное лечение — один ход и обычный расход еды.\nГолод учитывается. Работники не требуются." % [wounded_count(), people.size()]
		staffing_class.disabled = true
		staffing_add.disabled = true
		staffing_remove.disabled = true
	else:
		staffing_class.disabled = false

func change_staff(change: int) -> void:
	if not staffing_overlay.visible or not run_active or not on_map or selected_building == 3:
		return
	var staff := staff_at(map_position, selected_building)
	if change > 0:
		if staff.size() >= building_worker_capacity or people.size() <= 1:
			return
		var index := person_index(people, staffing_class.get_selected_id())
		if index < 0:
			return
		staff.append(people[index])
		people.remove_at(index)
	else:
		if staff.is_empty():
			return
		var index := person_index(staff, staffing_class.get_selected_id())
		if index < 0:
			return
		people.append(staff[index])
		staff.remove_at(index)
	expedition_size = people.size()
	show_map()
	open_staffing_menu(selected_building)

func demolish_building() -> void:
	if not run_active or not on_map or not staffing_overlay.visible:
		return
	if not buildings.has(map_position):
		return
	var building_name: String = BUILDING_NAMES[selected_building]
	if building_workers.has(map_position):
		for kind in building_workers[map_position]:
			for person in building_workers[map_position][kind]:
				people.append(person)
	building_workers.erase(map_position)
	buildings.erase(map_position)
	selected_building = -1
	consume_supplies()
	show_map()
	if run_active:
		result.text = "Снесено: %s. Прошёл 1 ход. Можно построить новое здание." % building_name

func close_staffing_menu() -> void:
	selected_building = -1
	show_map()

func random_enemy_count(floor_number: int, variation: float) -> int:
	return maxi(1, roundi(first_floor_enemies * floor_enemy_multiplier(floor_number) * enemy_multiplier * laboratory_multiplier() * variation))

func spawn_enemy_group(count: int) -> void:
	var weights: Array[float] = [maxf(0.0, 1.0 - heavy_enemy_share - ranged_enemy_share - fast_enemy_share), heavy_enemy_share, ranged_enemy_share, fast_enemy_share]
	var total := 0.0
	for i in range(weights.size()):
		weights[i] *= rng.randf_range(1.0 - enemy_composition_variation, 1.0 + enemy_composition_variation)
		total += weights[i]
	if total <= 0.0:
		weights[0] = 1.0
		total = 1.0
	# A broad front, two wings, or a compact group at a random height.
	var layout := rng.randi_range(0, 2)
	var columns := rng.randi_range(3, 7)
	var rows := ceili(count / float(columns))
	var center := rng.randf_range(270.0, 490.0)
	for i in range(count):
		var roll := rng.randf() * total
		var kind := 1
		for type_index in range(weights.size()):
			roll -= weights[type_index]
			if roll < 0.0:
				kind = type_index + 1
				break
		var progress := 0.5 if rows <= 1 else floori(i / float(columns)) / float(rows - 1)
		var y := lerpf(150.0, 620.0, progress)
		if layout == 1:
			y = lerpf(150.0, 300.0, progress * 2.0) if progress < 0.5 else lerpf(470.0, 620.0, (progress - 0.5) * 2.0)
		elif layout == 2:
			y = center + lerpf(-130.0, 130.0, progress)
		var x := 790.0 + (i % columns) * (220.0 / maxf(1.0, columns - 1))
		x += rng.randf_range(-enemy_spawn_jitter, enemy_spawn_jitter)
		y += rng.randf_range(-enemy_spawn_jitter, enemy_spawn_jitter)
		spawn_unit(kind, Vector2(clampf(x, 750.0, 1030.0), clampf(y, 140.0, 630.0)))

func spawn_unit(kind: int, pos: Vector2) -> void:
	var hp := human_hp
	var speed := human_speed
	var damage := human_damage * attack_multiplier * camp_multiplier()
	var interval := human_attack_interval
	var radius := human_radius
	var attack_range := 0.0
	match kind:
		1:
			hp = mushroom_hp
			speed = mushroom_speed
			damage = mushroom_damage
			interval = mushroom_attack_interval
			radius = mushroom_radius
		2:
			hp = heavy_hp
			speed = heavy_speed
			damage = heavy_damage
			interval = heavy_attack_interval
			radius = heavy_radius
		3:
			hp = ranged_hp
			speed = ranged_speed
			damage = ranged_damage
			interval = ranged_interval
			radius = ranged_radius
			attack_range = ranged_attack_range
		4:
			hp = fast_hp
			speed = fast_speed
			damage = fast_damage
			interval = fast_interval
			radius = fast_radius
		5:
			hp = boss_hp
			speed = boss_speed
			damage = boss_damage
			interval = boss_attack_interval
			radius = boss_radius
			attack_range = boss_attack_range
	units.append({"kind": kind, "pos": pos, "hp": hp, "max_hp": hp,
		"speed": speed, "damage": damage, "interval": interval,
		"cooldown": rng.randf_range(0.0, 0.6), "radius": radius,
		"attack_range": attack_range, "flash": 0.0, "retreat_time": 0.0, "retreat_rest": 0.0, "aim_time": 0.0, "shot_ready": false, "stand_time": 0.0})

func _process(delta: float) -> void:
	if transport_notice.visible:
		return
	if run_active and not transport_combat and not pending_ambushes.is_empty():
		begin_transport_combat(pending_ambushes.pop_front())
	if finished:
		return
	tick(minf(delta, 0.05))
	battle_canvas.queue_redraw()

func tick(dt: float) -> void:
	elapsed += dt
	update_projectiles(dt)
	update_lasers(dt)
	boss_pulse_time = maxf(0.0, boss_pulse_time - dt)
	for unit in units:
		if unit.hp <= 0:
			continue
		unit.cooldown = maxf(0.0, unit.cooldown - dt)
		unit.flash = maxf(0.0, unit.flash - dt)
		var target: Dictionary = {}
		var nearest := INF
		for other in units:
			if other.hp <= 0 or (unit.kind == 0) == (other.kind == 0):
				continue
			var distance: float = unit.pos.distance_squared_to(other.pos)
			if unit.kind == 4 and other.kind == 0 and other.person.class_id == 2:
				distance -= 1000000000.0
			if distance < nearest:
				nearest = distance
				target = other
		if target.is_empty():
			continue
		if unit.kind == 0 and (unit.person.class_id == 0 or unit.person.class_id == 2):
			if handle_ranged_movement(unit, target, dt):
				continue
		var offset: Vector2 = target.pos - unit.pos
		var reach: float = maxf(unit.radius + target.radius + 5.0, float(unit.get("attack_range", 0.0)))
		if offset.length() > reach:
			var direction := offset.normalized()
			var separation := Vector2.ZERO
			for ally in units:
				if ally == unit or ally.hp <= 0 or (ally.kind == 0) != (unit.kind == 0):
					continue
				var away: Vector2 = unit.pos - ally.pos
				var gap := away.length()
				var spacing: float = unit.radius + ally.radius + 2.0
				if gap > 0.01 and gap < spacing:
					separation += away / gap * (1.0 - gap / spacing)
			unit.pos += (direction + separation * 1.6).limit_length() * unit.speed * dt
			unit.pos = unit.pos.clamp(FIELD.position + Vector2.ONE * 15, FIELD.end - Vector2.ONE * 15)
		elif unit.cooldown <= 0.0:
			if unit.kind == 5:
				boss_pulse_time = 0.25
				boss_pulse_position = unit.pos
				for victim in units:
					if victim.kind == 0 and victim.hp > 0 and unit.pos.distance_to(victim.pos) <= boss_blast_radius + victim.radius:
						victim.hp = maxf(0.0, victim.hp - unit.damage)
						victim.flash = 0.12
			elif unit.kind == 3:
				projectiles.append({"pos": unit.pos, "target": target, "damage": unit.damage, "speed": spore_speed, "color": Color(0.95, 0.35, 0.85)})
			elif unit.kind == 0 and unit.person.class_id == 2:
				target.hp = maxf(0.0, target.hp - unit.damage)
				target.flash = 0.12
				laser_beams.append({"from": unit.pos, "to": target.pos, "time": scientist_laser_duration})
			elif unit.kind == 0 and unit.person.class_id == 0:
				projectiles.append({"pos": unit.pos, "target": target, "damage": unit.damage})
			else:
				target.hp = maxf(0.0, target.hp - unit.damage)
				target.flash = 0.12
			unit.cooldown = unit.interval
			if unit.kind == 0 and (unit.person.class_id == 0 or unit.person.class_id == 2):
				unit.shot_ready = false
				unit.stand_time = ranged_shot_pause
	var humans := 0
	var enemies := 0
	if not transport_combat:
		collect_monster_money()
	for unit in units:
		if unit.hp > 0:
			if unit.kind == 0:
				humans += 1
			else:
				enemies += 1
	update_status(humans, enemies)
	if humans == 0 or enemies == 0:
		if transport_combat:
			end_transport_combat(humans > 0)
			return
		finished = true
		if humans == 0:
			people.clear()
			expedition_size = 0
			finish_expedition(false)
		else:
			var survivors: Array[Dictionary] = []
			for unit in units:
				if unit.kind == 0 and unit.hp > 0:
					unit.person.health_fraction = maxf(clampf(post_battle_health_floor, 0.0, 1.0), float(unit.hp) / float(unit.max_hp))
					survivors.append(unit.person)
			people = survivors
			expedition_size = people.size()
			pickup_loot()
			if map_position == goal_cell:
				expedition_complete = true
				finish_expedition(true)
				return
			awaiting_choice = true
			choice_title.text = "Победа в бою %d! Выжило людей: %d.\nВыберите бонус и вернитесь на карту." % [battle_number, humans]
			battle_result.text = "Выжившие сохраняют ранения. Лазарет восстанавливает здоровье полностью."
			choices.show()

func draw_battle() -> void:
	if not run_active or on_map:
		return
	battle_canvas.draw_rect(Rect2(0, 0, 1100, 720), Color(0.055, 0.075, 0.09))
	battle_canvas.draw_rect(Rect2(0, 0, 1100, 720), Color(0.4, 0.5, 0.6), false, 2.0)
	battle_canvas.draw_rect(FIELD, Color(0.09, 0.12, 0.14))
	battle_canvas.draw_rect(FIELD, Color(0.22, 0.28, 0.30), false, 1.0)
	if boss_pulse_time > 0:
		var alpha := boss_pulse_time / 0.25
		battle_canvas.draw_circle(boss_pulse_position, boss_blast_radius, Color(0.9, 0.2, 0.6, alpha * 0.12))
		battle_canvas.draw_arc(boss_pulse_position, boss_blast_radius, 0, TAU, 64, Color(1.0, 0.3, 0.65, alpha), 3.0, true)
	for unit in units:
		var pos: Vector2 = unit.pos
		var radius: float = unit.radius
		if unit.hp <= 0:
			battle_canvas.draw_line(pos - Vector2(3, 3), pos + Vector2(3, 3), Color(0.25, 0.28, 0.29), 2)
			battle_canvas.draw_line(pos - Vector2(-3, 3), pos + Vector2(-3, 3), Color(0.25, 0.28, 0.29), 2)
			continue
		var color := Color(0.3, 0.72, 1.0) if unit.kind == 0 else (Color(0.95, 0.40, 0.35) if unit.kind == 2 else Color(0.55, 0.82, 0.35))
		if unit.kind == 5:
			color = Color(0.65, 0.15, 0.85)
		elif unit.kind == 3:
			color = Color(0.95, 0.35, 0.85)
		elif unit.kind == 4:
			color = Color(1.0, 0.55, 0.15)
		if unit.kind == 0:
			color = CLASS_COLORS[int(unit.person.class_id)]
		if unit.kind == 0 and unit.person.hunger > 0:
			color = Color(1.0, 0.65, 0.2) if unit.person.hunger == 1 else Color(1.0, 0.35, 0.2)
		if unit.flash > 0:
			color = Color.WHITE
		if unit.kind == 5:
			battle_canvas.draw_circle(pos, radius, color)
			battle_canvas.draw_arc(pos, radius + 5, 0, TAU, 48, Color(1.0, 0.65, 0.2), 3.0, true)
		elif unit.kind == 0:
			battle_canvas.draw_circle(pos, radius, color)
		else:
			battle_canvas.draw_rect(Rect2(pos - Vector2(radius, radius), Vector2.ONE * radius * 2), color)
		battle_canvas.draw_rect(Rect2(pos + Vector2(-radius, -radius - 6), Vector2(radius * 2, 3)), Color(0.2, 0.2, 0.2))
		battle_canvas.draw_rect(Rect2(pos + Vector2(-radius, -radius - 6), Vector2(radius * 2 * unit.hp / unit.max_hp, 3)), Color(0.4, 0.9, 0.65))
















	for shot in projectiles:
		battle_canvas.draw_circle(shot.pos, 3.0, shot.get("color", Color(1.0, 0.9, 0.4)))

	for beam in laser_beams:
		var opacity := clampf(float(beam.time) / maxf(scientist_laser_duration, 0.01), 0.0, 1.0)
		battle_canvas.draw_line(beam["from"], beam["to"], Color(0.7, 0.2, 1.0, opacity * 0.3), 9.0, true)
		battle_canvas.draw_line(beam["from"], beam["to"], Color(0.9, 0.65, 1.0, opacity), 3.0, true)
		battle_canvas.draw_line(beam["from"], beam["to"], Color(1.0, 0.95, 1.0, opacity), 1.0, true)
		battle_canvas.draw_circle(beam["to"], 5.0, Color(0.9, 0.5, 1.0, opacity))

func update_lasers(dt: float) -> void:
	var remaining: Array[Dictionary] = []
	for beam in laser_beams:
		beam.time -= dt
		if beam.time > 0:
			remaining.append(beam)
	laser_beams = remaining

func new_person(class_id: int) -> Dictionary:
	return {"hunger": 0, "class_id": class_id, "health_fraction": 1.0}

func class_hp_multiplier(class_id: int) -> float:
	match class_id:
		1: return warrior_hp_multiplier
		2: return scientist_hp_multiplier
		3: return cook_hp_multiplier
	return 1.0

func class_damage_multiplier(class_id: int) -> float:
	match class_id:
		1: return warrior_damage_multiplier
		2: return scientist_damage_multiplier
		3: return cook_damage_multiplier
	return 1.0

func class_count(group: Array, class_id: int) -> int:
	var total := 0
	for person in group:
		if person.class_id == class_id:
			total += 1
	return total

func person_index(group: Array, class_id: int) -> int:
	for i in range(group.size()):
		if group[i].class_id == class_id:
			return i
	return -1

func staff_power(staff: Array, building_type: int) -> float:
	var power := 0.0
	for person in staff:
		if person.class_id == 2 and (building_type == 0 or building_type == 2):
			power += scientist_work_multiplier
		elif person.class_id == 3 and building_type == 1:
			power += cook_work_multiplier
		else:
			power += 1.0
	return power

func workforce_power(building_type: int) -> float:
	var power := 0.0
	for cell in building_workers:
		if building_workers[cell].has(building_type):
			power += staff_power(building_workers[cell][building_type], building_type)
	return power

func on_staffing_class_selected(_index: int) -> void:
	refresh_staffing_menu()

func build_recruitment_screen() -> void:
	recruitment_panel = Panel.new()
	recruitment_panel.position = Vector2(140, 110)
	recruitment_panel.size = Vector2(820, 545)
	add_child(recruitment_panel)
	recruitment_info = Label.new()
	recruitment_info.position = Vector2(25, 20)
	recruitment_info.size = Vector2(770, 75)
	recruitment_info.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	recruitment_info.add_theme_font_size_override("font_size", 22)
	recruitment_panel.add_child(recruitment_info)
	for class_id in range(CLASS_NAMES.size()):
		var description := Label.new()
		description.position = Vector2(30, 115 + class_id * 75)
		description.size = Vector2(590, 65)
		description.text = CLASS_NAMES[class_id] + "\n" + class_description(class_id)
		description.modulate = CLASS_COLORS[class_id]
		recruitment_panel.add_child(description)
		var count := SpinBox.new()
		count.position = Vector2(640, 120 + class_id * 75)
		count.size = Vector2(140, 45)
		count.min_value = 0
		count.step = 1
		count.value_changed.connect(on_recruitment_changed.bind(class_id))
		recruitment_panel.add_child(count)
		recruitment_counts.append(count)
	var back := Button.new()
	back.position = Vector2(30, 450)
	back.size = Vector2(120, 60)
	back.text = "Назад"
	back.pressed.connect(show_meta_screen)
	recruitment_panel.add_child(back)
	var auto_distribute := Button.new()
	auto_distribute.position = Vector2(165, 450)
	auto_distribute.size = Vector2(230, 60)
	auto_distribute.text = "Авто-распределение"
	auto_distribute.tooltip_text = "50% воины · 30% стрелки · 10% учёные · 10% повара"
	auto_distribute.pressed.connect(auto_distribute_recruits)
	recruitment_panel.add_child(auto_distribute)
	recruitment_launch = Button.new()
	recruitment_launch.position = Vector2(410, 450)
	recruitment_launch.size = Vector2(370, 60)
	recruitment_launch.text = "Отправиться в экспедицию"
	recruitment_launch.pressed.connect(start_expedition)
	recruitment_panel.add_child(recruitment_launch)
	recruitment_panel.hide()

func class_description(class_id: int) -> String:
	match class_id:
		0:
			return "Здоровье %.0f · Урон %.1f · Дальняя атака" % [human_hp, human_damage]
		1:
			return "Здоровье %.0f · Урон %.1f · Ближний бой" % [human_hp * warrior_hp_multiplier, human_damage * warrior_damage_multiplier]
		2:
			return "Здоровье %.0f · Урон %.1f · Дальность %.0f · Работа ×%.1f" % [human_hp * scientist_hp_multiplier, human_damage * scientist_damage_multiplier, shooter_range * scientist_range_multiplier, scientist_work_multiplier]
		3:
			return "Здоровье %.0f · Урон %.1f · Кухня ×%.1f" % [human_hp * cook_hp_multiplier, human_damage * cook_damage_multiplier, cook_work_multiplier]
	return ""

func recruitment_total() -> int:
	var total := 0
	for count in recruitment_counts:
		total += int(count.value)
	return total

func open_recruitment() -> void:
	if run_active or meta_upgrade_available:
		return
	meta_panel.hide()
	recruitment_updating = true
	var pool := initial_people + meta_people_level * meta_people_bonus
	for count in recruitment_counts:
		count.max_value = pool
		count.value = 0
	recruitment_updating = false
	recruitment_panel.show()
	refresh_recruitment()

func on_recruitment_changed(_value: float, class_id: int) -> void:
	if recruitment_updating:
		return
	recruitment_updating = true
	var pool := initial_people + meta_people_level * meta_people_bonus
	var others := recruitment_total() - int(recruitment_counts[class_id].value)
	recruitment_counts[class_id].value = mini(int(recruitment_counts[class_id].value), maxi(0, pool - others))
	recruitment_updating = false
	refresh_recruitment()

func refresh_recruitment() -> void:
	var pool := initial_people + meta_people_level * meta_people_bonus
	var total := recruitment_total()
	recruitment_info.text = "НАБОР ЭКСПЕДИЦИИ\nПул: %d · Набрано: %d · Осталось: %d" % [pool, total, pool - total]
	recruitment_launch.disabled = total != pool or total == 0

func update_projectiles(dt: float) -> void:
	var remaining: Array[Dictionary] = []
	for shot in projectiles:
		var target: Dictionary = shot.target
		if target.hp <= 0:
			continue
		var offset: Vector2 = target.pos - shot.pos
		var travel := float(shot.get("speed", projectile_speed)) * dt
		if offset.length() <= travel + float(target.radius):
			target.hp = maxf(0.0, target.hp - float(shot.damage))
			target.flash = 0.12
		else:
			shot.pos += offset.normalized() * travel
			remaining.append(shot)
	projectiles = remaining

func auto_distribute_recruits() -> void:
	if run_active or not recruitment_panel.visible:
		return
	var pool := initial_people + meta_people_level * meta_people_bonus
	var weights := [0.3, 0.5, 0.1, 0.1]
	var counts: Array[int] = []
	var fractions: Array[float] = []
	var assigned := 0
	for class_id in range(CLASS_NAMES.size()):
		var exact: float = pool * weights[class_id]
		var count := floori(exact)
		counts.append(count)
		fractions.append(exact - count)
		assigned += count
	while assigned < pool:
		var best := 1
		for class_id in range(CLASS_NAMES.size()):
			if fractions[class_id] > fractions[best]:
				best = class_id
		counts[best] += 1
		fractions[best] = -1.0
		assigned += 1
	recruitment_updating = true
	for class_id in range(CLASS_NAMES.size()):
		recruitment_counts[class_id].value = counts[class_id]
	recruitment_updating = false
	refresh_recruitment()

func building_limit(kind: int) -> int:
	var initial := [initial_camp_slots, initial_kitchen_slots, initial_lab_slots, initial_hospital_slots]
	return int(initial[kind]) + purchased_building_slots[kind]

func building_price(kind: int) -> int:
	return int([camp_purchase_price, kitchen_purchase_price, lab_purchase_price, hospital_purchase_price][kind])

func used_building_slots(kind: int) -> int:
	var count := 0
	for cell in buildings:
		if buildings[cell].has(kind):
			count += 1
	return count

func buy_building_slot(kind: int) -> void:
	if run_active or not meta_panel.visible or kind < 0 or kind >= BUILDING_NAMES.size():
		return
	var price := building_price(kind)
	if money < price:
		return
	money -= price
	purchased_building_slots[kind] += 1
	save_meta_progress()
	update_meta_screen()

func sell_artifacts() -> void:
	if run_active or not meta_panel.visible or stored_artifacts <= 0:
		return
	money += stored_artifacts * artifact_sale_price
	stored_artifacts = 0
	save_meta_progress()
	update_meta_screen()

func resolve_artifact(use_now: bool) -> void:
	if not run_active or pending_event != 5 or not event_overlay.visible:
		return
	if use_now:
		attack_multiplier *= 1.0 + artifact_attack_growth
	else:
		stock_at(map_position).artifacts += 1
		pickup_loot()
	pending_event = -1
	if not visited.has(map_position):
		visited.append(map_position)
	show_map()
	result.text = "Артефакт использован: +%.0f%% атаки до конца экспедиции." % (artifact_attack_growth * 100.0) if use_now else "Артефакт доступен на этой клетке. Отправьте его на базу через меню «Грузы»."

func collect_monster_money() -> void:
	var earned := 0
	for unit in units:
		if unit.kind != 0 and unit.hp <= 0 and not bool(unit.get("bounty_claimed", false)):
			unit.bounty_claimed = true
			earned += money_per_boss if unit.kind == 5 else money_per_monster
	if earned > 0:
		stock_at(map_position).coins += earned
		pickup_loot()

func handle_ranged_movement(unit: Dictionary, target: Dictionary, dt: float) -> bool:
	unit.retreat_rest = maxf(0.0, unit.retreat_rest - dt)
	if unit.stand_time > 0.0:
		unit.stand_time = maxf(0.0, unit.stand_time - dt)
		return true
	var distance: float = unit.pos.distance_to(target.pos)
	var attack_range: float = unit.attack_range
	var danger_distance := shooter_retreat_distance if unit.person.class_id == 0 else scientist_retreat_distance
	if unit.aim_time > 0.0:
		if distance > attack_range + target.radius:
			unit.aim_time = 0.0
			unit.shot_ready = false
			return true
		unit.aim_time = maxf(0.0, unit.aim_time - dt)
		if unit.aim_time > 0.0:
			return true
		unit.shot_ready = true
	if unit.shot_ready:
		return false
	if unit.retreat_time > 0.0:
		unit.retreat_time = maxf(0.0, unit.retreat_time - dt)
		if distance >= danger_distance * 1.25 or unit.retreat_time <= 0.0:
			unit.retreat_time = 0.0
			unit.retreat_rest = retreat_recovery
		else:
			var escape := Vector2.ZERO
			for enemy in units:
				if enemy.kind == 0 or enemy.hp <= 0:
					continue
				var away: Vector2 = unit.pos - enemy.pos
				var gap := away.length()
				if gap < danger_distance * 1.25:
					escape += away.normalized() / maxf(gap, 10.0)
			if escape.length_squared() < 0.000001:
				escape = unit.pos - target.pos
			var old_position: Vector2 = unit.pos
			var next_position: Vector2 = old_position + escape.normalized() * unit.speed * retreat_speed_multiplier * dt
			var margin: float = unit.radius + 3.0
			unit.pos = next_position.clamp(FIELD.position + Vector2.ONE * margin, FIELD.end - Vector2.ONE * margin)
			if old_position.distance_squared_to(unit.pos) < 0.01:
				unit.retreat_time = 0.0
				unit.retreat_rest = retreat_recovery
			return true
	if distance < danger_distance and unit.retreat_rest <= 0.0 and unit.cooldown > 0.0:
		unit.retreat_time = max_retreat_duration
		return true
	if distance <= attack_range and unit.cooldown <= 0.0:
		unit.aim_time = ranged_aim_time
		return true
	return false

func stock_at(cell: Vector2i) -> Dictionary:
	if not cell_stocks.has(cell):
		cell_stocks[cell] = {"food": 0, "coins": 0, "artifacts": 0}
	return cell_stocks[cell]

func cargo_weight(food: int, coins: int, artifacts: int) -> int:
	return food + ceili(float(coins) / maxi(1, coins_per_weight)) + artifacts * artifact_weight

func cargo_capacity() -> int:
	return people.size() * carry_capacity_per_person

func pickup_loot() -> void:
	var stock := stock_at(map_position)
	var room := maxi(0, cargo_capacity() - cargo_weight(supplies, run_money, carried_artifacts))
	var coin_room := room * coins_per_weight + (ceili(float(run_money) / coins_per_weight) * coins_per_weight - run_money)
	var coins := mini(int(stock.coins), maxi(0, coin_room))
	run_money += coins
	stock.coins -= coins
	room = maxi(0, cargo_capacity() - cargo_weight(supplies, run_money, carried_artifacts))
	var artifacts := mini(int(stock.artifacts), floori(float(room) / artifact_weight))
	carried_artifacts += artifacts
	stock.artifacts -= artifacts

func safe_path_between(origin: Vector2i, destination: Vector2i) -> Array[Vector2i]:
	var queue: Array[Vector2i] = [origin]
	var parents: Dictionary = {origin: origin}
	var head := 0
	while head < queue.size():
		var cell: Vector2i = queue[head]
		head += 1
		if cell == destination:
			var path: Array[Vector2i] = [cell]
			while cell != origin:
				cell = parents[cell]
				path.append(cell)
			path.reverse()
			return path
		for direction in [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]:
			var neighbor: Vector2i = cell + direction
			if (visited.has(neighbor) or (neighbor == destination and destination == map_position)) and not parents.has(neighbor):
				parents[neighbor] = cell
				queue.append(neighbor)
	return []

func safe_path_to_base() -> Array[Vector2i]:
	return safe_path_between(map_position, start_cell)

func safe_distance_to_base() -> int:
	var path := safe_path_to_base()
	return -1 if path.is_empty() else path.size() - 1

func build_logistics_menu() -> void:
	logistics_overlay = ColorRect.new()
	logistics_overlay.size = Vector2(1100, 720)
	logistics_overlay.color = Color(0, 0, 0, 0.8)
	logistics_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(logistics_overlay)
	var panel := Panel.new()
	panel.position = Vector2(100, 90)
	panel.size = Vector2(900, 555)
	logistics_overlay.add_child(panel)
	logistics_info = Label.new()
	logistics_info.position = Vector2(25, 15)
	logistics_info.size = Vector2(850, 80)
	panel.add_child(logistics_info)
	logistics_job = OptionButton.new()
	logistics_job.position = Vector2(30, 100)
	logistics_job.size = Vector2(840, 40)
	logistics_job.item_selected.connect(on_logistics_job_selected)
	panel.add_child(logistics_job)
	var names := ["Еда", "Монеты", "Артефакты"]
	for i in range(3):
		var label := Label.new()
		label.position = Vector2(30 + i * 285, 145)
		label.text = names[i]
		panel.add_child(label)
		var input := SpinBox.new()
		input.position = Vector2(30 + i * 285, 170)
		input.size = Vector2(245, 45)
		input.min_value = 0
		input.step = 1
		input.value_changed.connect(on_logistics_changed)
		panel.add_child(input)
		cargo_inputs.append(input)
	pickup_button = logistics_action(panel, "Забрать со склада", Vector2(30, 225), transfer_cargo.bind(true))
	deposit_button = logistics_action(panel, "Оставить на клетке", Vector2(315, 225), transfer_cargo.bind(false))
	logistics_action(panel, "Все находки в рюкзак", Vector2(600, 225), pickup_all_loot)
	for class_id in range(4):
		var label := Label.new()
		label.position = Vector2(30 + class_id * 215, 290)
		label.text = CLASS_NAMES[class_id]
		panel.add_child(label)
		var input := SpinBox.new()
		input.position = Vector2(30 + class_id * 215, 315)
		input.size = Vector2(195, 45)
		input.min_value = 0
		input.step = 1
		input.value_changed.connect(on_logistics_changed)
		panel.add_child(input)
		convoy_inputs.append(input)
	logistics_message = Label.new()
	logistics_message.position = Vector2(30, 375)
	logistics_message.size = Vector2(840, 90)
	logistics_message.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	panel.add_child(logistics_message)
	send_convoy_button = logistics_action(panel, "Отправить на базу", Vector2(30, 475), dispatch_convoy)
	logistics_action(panel, "Подождать · 1 ход", Vector2(315, 475), wait_logistics_turn)
	logistics_action(panel, "Закрыть", Vector2(600, 475), close_logistics_menu)
	logistics_overlay.hide()

func logistics_action(panel: Control, label: String, position: Vector2, action: Callable) -> Button:
	var button := Button.new()
	button.position = position
	button.size = Vector2(245, 50)
	button.text = label
	button.pressed.connect(action)
	panel.add_child(button)
	return button

func open_logistics_menu() -> void:
	if not run_active or not on_map or pending_event >= 0 or construction_overlay.visible or staffing_overlay.visible:
		return
	for input in cargo_inputs:
		input.value = 0
	for input in convoy_inputs:
		input.value = 0
	kitchen_destinations.clear()
	logistics_job.clear()
	logistics_job.add_item("Отправить груз на верхнюю базу")
	for cell in buildings:
		if buildings[cell].has(1) and cell != map_position:
			kitchen_destinations.append(cell)
			logistics_job.add_item("Принести еду: кухня на этаже %d · Запас %d" % [cell.y, int(stock_at(cell).food)])
	logistics_job.select(0)
	logistics_overlay.show()
	refresh_logistics()

func on_logistics_changed(_value: float) -> void:
	if logistics_overlay.visible:
		refresh_logistics()

func selected_crew_count() -> int:
	var count := 0
	for input in convoy_inputs:
		count += int(input.value)
	return count

func refresh_logistics() -> void:
	if logistics_job.selected > 0:
		refresh_fetch_job()
		return
	cargo_inputs[1].editable = true
	cargo_inputs[2].editable = true
	send_convoy_button.text = "Отправить на базу"
	var stock := stock_at(map_position)
	var local_values := [int(stock.food), int(stock.coins), int(stock.artifacts)]
	var carried := [supplies, run_money, carried_artifacts]
	for i in range(3):
		cargo_inputs[i].max_value = maxi(local_values[i], carried[i])
	for class_id in range(4):
		convoy_inputs[class_id].max_value = class_count(people, class_id)
	logistics_info.text = "ГРУЗЫ / СНАБЖЕНИЕ\nС собой: еда %d · монеты %d · артефакты %d · вес %d/%d\nЗдесь: еда %d · монеты %d · артефакты %d · На базе: %d монет" % [supplies, run_money, carried_artifacts, cargo_weight(supplies, run_money, carried_artifacts), cargo_capacity(), stock.food, stock.coins, stock.artifacts, money]
	var food := int(cargo_inputs[0].value)
	var coins := int(cargo_inputs[1].value)
	var artifacts := int(cargo_inputs[2].value)
	var crew := selected_crew_count()
	var distance := safe_distance_to_base()
	var provisions := maxi(0, distance) * crew * supplies_per_person
	var cargo := cargo_weight(food + provisions, coins, artifacts)
	var main_load := cargo_weight(supplies - food - provisions, run_money - coins, carried_artifacts - artifacts)
	var valid_payload := food <= supplies and coins <= run_money and artifacts <= carried_artifacts and supplies >= food + provisions
	send_convoy_button.disabled = crew <= 0 or crew >= people.size() or distance < 0 or not valid_payload or cargo > crew * carry_capacity_per_person or main_load > (people.size() - crew) * carry_capacity_per_person or food + coins + artifacts == 0
	deposit_button.disabled = food > supplies or coins > run_money or artifacts > carried_artifacts or food + coins + artifacts == 0
	pickup_button.disabled = food > stock.food or coins > stock.coins or artifacts > stock.artifacts or food + coins + artifacts == 0 or cargo_weight(supplies + food, run_money + coins, carried_artifacts + artifacts) > cargo_capacity()
	var flights := PackedStringArray()
	for convoy in convoys:
		flights.append("%d чел. / %d ход." % [convoy.crew.size(), convoy.turns])
	logistics_message.text = "Доставка наверх: %d ход. · Людей: %d · Провизия на дорогу: %d · Груз каравана: %d/%d\nПосле отправки люди остаются на базе до следующего рана.\nВ пути: %s" % [maxi(0, distance), crew, provisions, cargo, crew * carry_capacity_per_person, "нет" if flights.is_empty() else ", ".join(flights)]
	send_convoy_button.tooltip_text = "Выберите груз и людей. Нужны еда на путь и вместимость у обеих групп."

func transfer_cargo(pickup: bool) -> void:
	if not logistics_overlay.visible or not run_active:
		return
	refresh_logistics()
	if (pickup and pickup_button.disabled) or (not pickup and deposit_button.disabled):
		return
	var stock := stock_at(map_position)
	var direction := 1 if pickup else -1
	var food := int(cargo_inputs[0].value)
	var coins := int(cargo_inputs[1].value)
	var artifacts := int(cargo_inputs[2].value)
	supplies += food * direction
	run_money += coins * direction
	carried_artifacts += artifacts * direction
	stock.food -= food * direction
	stock.coins -= coins * direction
	stock.artifacts -= artifacts * direction
	if map_position == start_cell:
		bank_base_stock()
	refresh_logistics()

func pickup_all_loot() -> void:
	if not logistics_overlay.visible:
		return
	pickup_loot()
	refresh_logistics()

func dispatch_convoy() -> void:
	if not logistics_overlay.visible or not run_active:
		return
	refresh_logistics()
	if send_convoy_button.disabled:
		return
	if logistics_job.selected > 0:
		dispatch_food_fetch()
		return
	var distance := safe_distance_to_base()
	var crew: Array[Dictionary] = []
	for class_id in range(4):
		for i in range(int(convoy_inputs[class_id].value)):
			var index := person_index(people, class_id)
			crew.append(people[index])
			people.remove_at(index)
	var food := int(cargo_inputs[0].value)
	var coins := int(cargo_inputs[1].value)
	var artifacts := int(cargo_inputs[2].value)
	supplies -= food + distance * crew.size() * supplies_per_person
	run_money -= coins
	carried_artifacts -= artifacts
	var convoy := {"crew": crew, "turns": distance, "food": food, "coins": coins, "artifacts": artifacts, "path": safe_path_to_base(), "path_index": 0, "cell": map_position}
	if distance == 0:
		complete_convoy(convoy)
	else:
		convoys.append(convoy)
	expedition_size = people.size()
	show_map()
	result.text = "Караван отправлен: %d человек, доставка через %d ходов." % [crew.size(), distance]

func advance_convoys() -> void:
	var remaining: Array[Dictionary] = []
	for convoy in convoys:
		if bool(convoy.get("ambush_pending", false)):
			remaining.append(convoy)
			continue
		if bool(convoy.get("fetch", false)):
			if advance_food_fetch(convoy):
				remaining.append(convoy)
			continue
		convoy.turns -= 1
		convoy.path_index = mini(int(convoy.path_index) + 1, convoy.path.size() - 1)
		convoy.cell = convoy.path[int(convoy.path_index)]
		if queue_convoy_ambush(convoy):
			remaining.append(convoy)
			continue
		if convoy.turns <= 0:
			complete_convoy(convoy)
		else:
			remaining.append(convoy)
	convoys = remaining

func complete_convoy(convoy: Dictionary) -> void:
	if bool(convoy.get("fetch", false)):
		if run_active:
			people.append_array(convoy.crew)
			var room := maxi(0, cargo_capacity() - cargo_weight(supplies, run_money, carried_artifacts))
			var amount := mini(int(convoy.food), room)
			supplies += amount
			stock_at(map_position).food += int(convoy.food) - amount
		return
	money += int(convoy.coins)
	stored_artifacts += int(convoy.artifacts)
	stock_at(start_cell).food += int(convoy.food)
	save_meta_progress()

func bank_base_stock() -> void:
	var stock := stock_at(start_cell)
	money += int(stock.coins)
	stored_artifacts += int(stock.artifacts)
	stock.coins = 0
	stock.artifacts = 0
	save_meta_progress()

func wait_logistics_turn() -> void:
	if not run_active or not logistics_overlay.visible:
		return
	consume_supplies()
	show_map()

func close_logistics_menu() -> void:
	show_map()


func wounded_count() -> int:
	var count := 0
	for person in people:
		if float(person.get("health_fraction", 1.0)) < 0.999:
			count += 1
	return count

func heal_at_hospital() -> void:
	if not run_active or not on_map or not staffing_overlay.visible or selected_building != 3:
		return
	if not buildings.has(map_position) or not buildings[map_position].has(3) or wounded_count() == 0:
		return
	consume_supplies()
	for person in people:
		person.health_fraction = 1.0
	show_map()
	if run_active:
		result.text = "Лазарет: здоровье отряда восстановлено до 100%. Прошёл один ход."

func update_convoy_markers() -> void:
	for marker in convoy_markers:
		marker.hide()
	var counts: Dictionary = {}
	for convoy in convoys:
		var cell: Vector2i = convoy.cell
		var index := (cell.y - 1) * map_columns + cell.x - 1
		if index < 0 or index >= convoy_markers.size():
			continue
		counts[index] = int(counts.get(index, 0)) + 1
		var marker: Label = convoy_markers[index]
		marker.text = "◆" if counts[index] == 1 else "◆%d" % counts[index]
		marker.show()
		map_buttons[index].tooltip_text += "\nКараван: %d человек · Еда %d · Монеты %d · Артефакты %d\nДо доставки: ~%d ходов" % [convoy.crew.size(), convoy.food, convoy.coins, convoy.artifacts, convoy.turns] + ("\nЗа едой на кухню / обратно к отряду" if bool(convoy.get("fetch", false)) else "\nДоставка добычи на базу")

func pickup_kitchen_food() -> void:
	if not run_active or not on_map or not staffing_overlay.visible or selected_building != 1:
		return
	if not buildings.has(map_position) or not buildings[map_position].has(1):
		return
	var stock := stock_at(map_position)
	var room := maxi(0, cargo_capacity() - cargo_weight(supplies, run_money, carried_artifacts))
	var amount := mini(int(stock.food), room)
	if amount <= 0:
		return
	supplies += amount
	stock.food -= amount
	show_map()
	open_staffing_menu(1)

func on_logistics_job_selected(_index: int) -> void:
	refresh_logistics()

func refresh_fetch_job() -> void:
	var kitchen: Vector2i = kitchen_destinations[logistics_job.selected - 1]
	var stock := stock_at(kitchen)
	cargo_inputs[0].max_value = int(stock.food)
	cargo_inputs[1].editable = false
	cargo_inputs[2].editable = false
	for class_id in range(4):
		convoy_inputs[class_id].max_value = class_count(people, class_id)
	var path := safe_path_between(map_position, kitchen)
	var distance := path.size() - 1
	var crew := selected_crew_count()
	var requested := int(cargo_inputs[0].value)
	var provisions := maxi(0, distance) * crew * supplies_per_person
	var capacity := crew * carry_capacity_per_person
	var main_load := cargo_weight(supplies - provisions, run_money, carried_artifacts)
	logistics_info.text = "ПОДВОЗ ЕДЫ / кухня на этаже %d\nНа кухне: %d еды · У отряда: %d\nВыберите еду и носильщиков. Они вернутся к экспедиции." % [kitchen.y, stock.food, supplies]
	pickup_button.disabled = true
	deposit_button.disabled = true
	send_convoy_button.text = "Послать за едой"
	send_convoy_button.disabled = crew <= 0 or crew >= people.size() or distance < 0 or requested <= provisions or requested > capacity or supplies < provisions or provisions > capacity or main_load > (people.size() - crew) * carry_capacity_per_person
	logistics_message.text = "Путь: примерно %d ходов туда-обратно. Провизия до кухни: %d.\nЗабрать: %d · На обратный путь уйдёт примерно %d · Привезут ~%d.\nЕсли отряд уйдёт дальше, обратный путь и расход могут вырасти." % [maxi(0, distance) * 2, provisions, requested, provisions, maxi(0, requested - provisions)]
	send_convoy_button.tooltip_text = "Нужны носильщики, провизия до кухни и еда на обратную дорогу. В отряде должен остаться человек."

func dispatch_food_fetch() -> void:
	var kitchen: Vector2i = kitchen_destinations[logistics_job.selected - 1]
	var path := safe_path_between(map_position, kitchen)
	if path.is_empty():
		return
	var crew: Array[Dictionary] = []
	for class_id in range(4):
		for i in range(int(convoy_inputs[class_id].value)):
			var index := person_index(people, class_id)
			crew.append(people[index])
			people.remove_at(index)
	var provisions := (path.size() - 1) * crew.size() * supplies_per_person
	supplies -= provisions
	convoys.append({"fetch": true, "returning": false, "kitchen": kitchen, "requested": int(cargo_inputs[0].value), "crew": crew, "provisions": provisions, "food": 0, "coins": 0, "artifacts": 0, "cell": map_position, "turns": (path.size() - 1) * 2})
	expedition_size = people.size()
	show_map()
	result.text = "Носильщики отправились за едой. Вернутся к отряду; их путь виден на карте."

func advance_food_fetch(convoy: Dictionary) -> bool:
	var destination: Vector2i = map_position if bool(convoy.returning) else convoy.kitchen
	var path := safe_path_between(convoy.cell, destination)
	if path.size() > 1:
		convoy.cell = path[1]
		if queue_convoy_ambush(convoy):
			return true
	if bool(convoy.returning) and convoy.cell == map_position:
		convoy.food += int(convoy.provisions)
		convoy.provisions = 0
		complete_convoy(convoy)
		return false
	var survivors: Array[Dictionary] = []
	for person in convoy.crew:
		if convoy.provisions >= supplies_per_person:
			convoy.provisions -= supplies_per_person
			person.hunger = 0
		elif convoy.food >= supplies_per_person:
			convoy.food -= supplies_per_person
			person.hunger = 0
		else:
			person.hunger += 1
		if person.hunger < hunger_death_steps:
			survivors.append(person)
	convoy.crew = survivors
	if survivors.is_empty():
		stock_at(convoy.cell).food += int(convoy.food) + int(convoy.provisions)
		return false
	if not bool(convoy.returning) and convoy.cell == convoy.kitchen:
		var stock := stock_at(convoy.kitchen)
		var capacity := maxi(0, survivors.size() * carry_capacity_per_person - int(convoy.provisions))
		var amount := mini(int(convoy.requested), mini(int(stock.food), capacity))
		convoy.food += amount
		stock.food -= amount
		convoy.returning = true
	if bool(convoy.returning) and convoy.cell == map_position:
		convoy.food += int(convoy.provisions)
		convoy.provisions = 0
		complete_convoy(convoy)
		return false
	var return_path := safe_path_between(convoy.cell, map_position)
	if bool(convoy.returning):
		convoy.turns = maxi(0, return_path.size() - 1)
	else:
		var outbound := safe_path_between(convoy.cell, convoy.kitchen)
		var back := safe_path_between(convoy.kitchen, map_position)
		convoy.turns = maxi(0, outbound.size() - 1) + maxi(0, back.size() - 1)
	return true


func queue_convoy_ambush(convoy: Dictionary) -> bool:
	if convoy.crew.is_empty() or bool(convoy.get("ambush_pending", false)):
		return false
	if rng.randf() >= convoy_ambush_chance:
		return false
	convoy.ambush_pending = true
	pending_ambushes.append(convoy)
	return true

func begin_transport_combat(convoy: Dictionary) -> void:
	attacked_convoy = convoy
	transport_snapshot = {
		"units": units, "people": people, "projectiles": projectiles, "lasers": laser_beams,
		"elapsed": elapsed, "finished": finished, "on_map": on_map, "position": map_position,
		"starting_humans": starting_humans, "starting_enemies": starting_enemies,
		"expedition_size": expedition_size, "boss": boss_unit, "pulse": boss_pulse_time,
		"pulse_position": boss_pulse_position, "awaiting_choice": awaiting_choice,
		"status_text": status.text, "result_text": result.text,
		"battle_status": battle_status.text, "battle_result": battle_result.text,
		"battle_visible": battle_overlay.visible, "choices_visible": choices.visible,
		"status_visible": status.visible, "result_visible": result.visible,
		"construction_visible": construction_overlay.visible, "staffing_visible": staffing_overlay.visible,
		"event_visible": event_overlay.visible, "logistics_visible": logistics_overlay.visible
	}
	transport_combat = true
	units = []
	people = []
	people.append_array(convoy.crew)
	projectiles = []
	laser_beams = []
	boss_unit = {}
	boss_pulse_time = 0.0
	elapsed = 0.0
	finished = false
	on_map = false
	awaiting_choice = false
	map_position = convoy.cell
	starting_humans = people.size()
	starting_enemies = random_enemy_count(map_position.y, rng.randf_range(1.0 - enemy_count_variation, 1.0 + enemy_count_variation))
	var order := [1, 0, 3, 2]
	for rank in range(order.size()):
		var class_id: int = order[rank]
		var group: Array[Dictionary] = []
		for person in people:
			if person.class_id == class_id:
				group.append(person)
		var rows := ceili(group.size() / 3.0)
		for i in range(group.size()):
			var y := 385.0 if rows <= 1 else 150.0 + floori(i / 3.0) * 470.0 / (rows - 1)
			spawn_unit(0, Vector2(420 - rank * 90 - (i % 3) * 20, y))
			var unit: Dictionary = units[-1]
			unit.person = group[i]
			unit.max_hp *= class_hp_multiplier(class_id)
			unit.hp = unit.max_hp * float(group[i].get("health_fraction", 1.0))
			unit.damage *= class_damage_multiplier(class_id) * maxf(0.0, 1.0 - hunger_damage_loss * float(group[i].hunger))
			unit.attack_range = shooter_range if class_id == 0 else (shooter_range * scientist_range_multiplier if class_id == 2 else 0.0)
	spawn_enemy_group(starting_enemies)
	status.hide()
	result.hide()
	choices.hide()
	construction_overlay.hide()
	staffing_overlay.hide()
	event_overlay.hide()
	logistics_overlay.hide()
	battle_overlay.show()
	battle_result.text = "НАПАДЕНИЕ НА КАРАВАН! Экспедиция приостановлена. Носильщики сражаются автоматически."
	update_status(starting_humans, starting_enemies)
	battle_canvas.queue_redraw()

func end_transport_combat(victory: bool) -> void:
	var survivors: Array[Dictionary] = []
	var bounty := 0
	for unit in units:
		if unit.kind == 0 and unit.hp > 0:
			unit.person.health_fraction = maxf(post_battle_health_floor, float(unit.hp) / float(unit.max_hp))
			survivors.append(unit.person)
		elif unit.kind != 0 and unit.hp <= 0:
			bounty += money_per_monster
	attacked_convoy.crew = survivors
	attacked_convoy.ambush_pending = false
	var stock := stock_at(attacked_convoy.cell)
	stock.coins += bounty
	var summary := "Караван отбился! Выжило %d из %d. Доставка продолжится." % [survivors.size(), starting_humans]
	if not victory:
		stock.food += int(attacked_convoy.food) + int(attacked_convoy.get("provisions", 0))
		stock.coins += int(attacked_convoy.coins)
		stock.artifacts += int(attacked_convoy.artifacts)
		summary = "Караван погиб. Груз остался на клетке этажа %d." % int(attacked_convoy.cell.y)
		remove_convoy_identity(attacked_convoy)
	else:
		var room := survivors.size() * carry_capacity_per_person
		var food := int(attacked_convoy.food) + int(attacked_convoy.get("provisions", 0))
		var weight := cargo_weight(food, int(attacked_convoy.coins), int(attacked_convoy.artifacts))
		if weight > room:
			var drop := mini(int(attacked_convoy.food), weight - room)
			attacked_convoy.food -= drop
			stock.food += drop
			weight -= drop
			var provision_drop := mini(int(attacked_convoy.get("provisions", 0)), maxi(0, weight - room))
			attacked_convoy["provisions"] = int(attacked_convoy.get("provisions", 0)) - provision_drop
			stock.food += provision_drop
			weight -= provision_drop
			while weight > room and attacked_convoy.artifacts > 0:
				attacked_convoy.artifacts -= 1
				stock.artifacts += 1
				weight = cargo_weight(int(attacked_convoy.food) + int(attacked_convoy.get("provisions", 0)), int(attacked_convoy.coins), int(attacked_convoy.artifacts))
			if weight > room:
				stock.coins += int(attacked_convoy.coins)
				attacked_convoy.coins = 0
	units = transport_snapshot.units
	people = transport_snapshot.people
	projectiles = transport_snapshot.projectiles
	laser_beams = transport_snapshot.lasers
	elapsed = transport_snapshot.elapsed
	finished = transport_snapshot.finished
	on_map = transport_snapshot.on_map
	map_position = transport_snapshot.position
	starting_humans = transport_snapshot.starting_humans
	starting_enemies = transport_snapshot.starting_enemies
	expedition_size = transport_snapshot.expedition_size
	boss_unit = transport_snapshot.boss
	boss_pulse_time = transport_snapshot.pulse
	boss_pulse_position = transport_snapshot.pulse_position
	awaiting_choice = transport_snapshot.awaiting_choice
	status.text = transport_snapshot.status_text
	result.text = transport_snapshot.result_text
	battle_status.text = transport_snapshot.battle_status
	battle_result.text = transport_snapshot.battle_result
	battle_overlay.visible = transport_snapshot.battle_visible
	choices.visible = transport_snapshot.choices_visible
	status.visible = transport_snapshot.status_visible
	result.visible = transport_snapshot.result_visible
	construction_overlay.visible = transport_snapshot.construction_visible
	staffing_overlay.visible = transport_snapshot.staffing_visible
	event_overlay.visible = transport_snapshot.event_visible
	logistics_overlay.visible = transport_snapshot.logistics_visible
	transport_combat = false
	if victory and not bool(attacked_convoy.get("fetch", false)) and attacked_convoy.turns <= 0:
		complete_convoy(attacked_convoy)
		remove_convoy_identity(attacked_convoy)
	transport_notice_text.text = summary
	transport_notice.show()
	battle_canvas.queue_redraw()

func remove_convoy_identity(target: Dictionary) -> void:
	var remaining: Array[Dictionary] = []
	for convoy in convoys:
		if not is_same(convoy, target):
			remaining.append(convoy)
	convoys = remaining

func build_transport_notice() -> void:
	transport_notice = ColorRect.new()
	transport_notice.size = Vector2(1100, 720)
	transport_notice.color = Color(0, 0, 0, 0.75)
	transport_notice.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(transport_notice)
	var panel := Panel.new()
	panel.position = Vector2(290, 250)
	panel.size = Vector2(520, 220)
	transport_notice.add_child(panel)
	transport_notice_text = Label.new()
	transport_notice_text.position = Vector2(25, 25)
	transport_notice_text.size = Vector2(470, 100)
	transport_notice_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	transport_notice_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	panel.add_child(transport_notice_text)
	var confirm := Button.new()
	confirm.position = Vector2(160, 145)
	confirm.size = Vector2(200, 50)
	confirm.text = "Продолжить"
	confirm.pressed.connect(close_transport_notice)
	panel.add_child(confirm)
	transport_notice.hide()

func close_transport_notice() -> void:
	transport_notice.hide()
	if pending_expedition_end >= 0 and pending_ambushes.is_empty():
		var victory := pending_expedition_end == 1
		pending_expedition_end = -1
		finish_expedition(victory)
		return
	if on_map and pending_event < 0 and not construction_overlay.visible and not staffing_overlay.visible and not logistics_overlay.visible:
		show_map()
