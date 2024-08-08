alias ScheduleAdjApp.Repo
alias ScheduleAdjApp.Events.{Event, EventDate}
alias ScheduleAdjApp.Users.{User, UserDate}

# eventsテーブルのデータ
event1 = %Event{title: "Party", memo: "", status: 0}
event2 = %Event{title: "Meeting", memo: "Online", status: 1}
event3 = %Event{title: "Camp", memo: "Have fun", status: 0}

Repo.insert(event1)
Repo.insert(event2)
Repo.insert(event3)

# event_datesテーブルのデータ
# event date id = 1
event_dates =
  [
    %EventDate{event_dates: DateTime.new!(~D"2024-07-31", ~T"15:30:00"), event_id: 1},
    # 2
    %EventDate{event_dates: DateTime.new!(~D"2024-07-31", ~T"16:00:00"), event_id: 1},
    # 3
    %EventDate{event_dates: DateTime.new!(~D"2024-07-31", ~T"16:30:00"), event_id: 1},
    # 4
    %EventDate{event_dates: DateTime.new!(~D"2024-07-31", ~T"17:00:00"), event_id: 1},
    # 5
    %EventDate{event_dates: DateTime.new!(~D"2024-07-31", ~T"17:30:00"), event_id: 1},
    # 6
    %EventDate{event_dates: DateTime.new!(~D"2024-08-05", ~T"17:00:00"), event_id: 2},
    # 7
    %EventDate{event_dates: DateTime.new!(~D"2024-08-05", ~T"17:30:00"), event_id: 2},
    # 8
    %EventDate{event_dates: DateTime.new!(~D"2024-08-06", ~T"17:00:00"), event_id: 2},
    # 9
    %EventDate{event_dates: DateTime.new!(~D"2024-08-06", ~T"17:30:00"), event_id: 2},
    # 10
    %EventDate{event_dates: DateTime.new!(~D"2024-08-06", ~T"09:00:00"), event_id: 3},
    # 11
    %EventDate{event_dates: DateTime.new!(~D"2024-08-06", ~T"09:00:00"), event_id: 3},
    # 12
    %EventDate{event_dates: DateTime.new!(~D"2024-08-07", ~T"09:00:00"), event_id: 3},
    # 13
    %EventDate{event_dates: DateTime.new!(~D"2024-08-08", ~T"09:00:00"), event_id: 3},
    # 14
    %EventDate{event_dates: DateTime.new!(~D"2024-08-13", ~T"09:00:00"), event_id: 3},
    # 15
    %EventDate{event_dates: DateTime.new!(~D"2024-08-14", ~T"09:00:00"), event_id: 3},
    # 16
    %EventDate{event_dates: DateTime.new!(~D"2024-08-15", ~T"09:00:00"), event_id: 3},
    # 17
    %EventDate{event_dates: DateTime.new!(~D"2024-08-20", ~T"09:00:00"), event_id: 3},
    # 18
    %EventDate{event_dates: DateTime.new!(~D"2024-08-21", ~T"09:00:00"), event_id: 3},
    # 19
    %EventDate{event_dates: DateTime.new!(~D"2024-08-22", ~T"09:00:00"), event_id: 3}
  ]

Enum.map(event_dates, fn x -> Repo.insert(x) end)

# userテーブルのデータ
# user id = 1
users =
  [
    %User{name: "taro", pass: "a", memo: "", event_id: 1},
    # 2
    %User{name: "jiro", pass: "b", memo: "", event_id: 1},
    # 3
    %User{name: "saburo", pass: "c", memo: "", event_id: 1},
    # 4
    %User{name: "siro", pass: "d", memo: "", event_id: 1},
    # 5
    %User{name: "goro", pass: "e", memo: "", event_id: 2},
    # 6
    %User{name: "goro", pass: "e", memo: "", event_id: 2},
    # 7
    %User{name: "goro", pass: "e", memo: "", event_id: 2},
    # 8
    %User{name: "rokuro", pass: "f", memo: "", event_id: 2},
    # 9
    %User{name: "sitiro", pass: "g", memo: "", event_id: 3},
    # 10
    %User{name: "hatiro", pass: "h", memo: "", event_id: 3},
    # 11
    %User{name: "kuro", pass: "f", memo: "", event_id: 3},
    # 12
    %User{name: "ai", pass: "d", memo: "", event_id: 3},
    # 13
    %User{name: "kaori", pass: "s", memo: "", event_id: 3},
    # 14
    %User{name: "hanako", pass: "a", memo: "", event_id: 3}
  ]

Enum.map(users, fn x -> Repo.insert(x) end)

# user_datesテーブルのデータ
user_dates =
  [
    %UserDate{user_id: 1, event_date_id: 1},
    %UserDate{user_id: 1, event_date_id: 2},
    %UserDate{user_id: 1, event_date_id: 3},
    %UserDate{user_id: 1, event_date_id: 4},
    %UserDate{user_id: 1, event_date_id: 5},
    %UserDate{user_id: 2, event_date_id: 2},
    %UserDate{user_id: 2, event_date_id: 3},
    %UserDate{user_id: 2, event_date_id: 4},
    %UserDate{user_id: 2, event_date_id: 5},
    %UserDate{user_id: 3, event_date_id: 1},
    %UserDate{user_id: 3, event_date_id: 3},
    %UserDate{user_id: 3, event_date_id: 4},
    %UserDate{user_id: 3, event_date_id: 5},
    %UserDate{user_id: 4, event_date_id: 1},
    %UserDate{user_id: 4, event_date_id: 2},
    %UserDate{user_id: 4, event_date_id: 4},
    %UserDate{user_id: 4, event_date_id: 5},
    %UserDate{user_id: 5, event_date_id: 7},
    %UserDate{user_id: 5, event_date_id: 9},
    %UserDate{user_id: 6, event_date_id: 6},
    %UserDate{user_id: 6, event_date_id: 7},
    %UserDate{user_id: 6, event_date_id: 9},
    %UserDate{user_id: 7, event_date_id: 8},
    %UserDate{user_id: 7, event_date_id: 9},
    %UserDate{user_id: 8, event_date_id: 6},
    %UserDate{user_id: 8, event_date_id: 8},
    %UserDate{user_id: 8, event_date_id: 9},
    %UserDate{user_id: 9, event_date_id: 10},
    %UserDate{user_id: 9, event_date_id: 11},
    %UserDate{user_id: 9, event_date_id: 12},
    %UserDate{user_id: 9, event_date_id: 13},
    %UserDate{user_id: 10, event_date_id: 18},
    %UserDate{user_id: 10, event_date_id: 19},
    %UserDate{user_id: 11, event_date_id: 10},
    %UserDate{user_id: 11, event_date_id: 19},
    %UserDate{user_id: 12, event_date_id: 11},
    %UserDate{user_id: 12, event_date_id: 12},
    %UserDate{user_id: 12, event_date_id: 13},
    %UserDate{user_id: 12, event_date_id: 14},
    %UserDate{user_id: 12, event_date_id: 19},
    %UserDate{user_id: 14, event_date_id: 18},
    %UserDate{user_id: 14, event_date_id: 19}
  ]

Enum.map(user_dates, fn x -> Repo.insert(x) end)
