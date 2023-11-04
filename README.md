## Database ER Diagram
Copy the following code and paste into https://dbdiagram.io/d to see the diagram.
```
Table UserTable as UT {
  uid int [pk, increment, not null, unique]
  email varchar [not null, unique]
  username varchar [not null, unique]
}

Table UserInformation as UI {
  email varchar [pk, ref: > UT.email, not null, unique,  note: "ON DELETE CASCADE"]
  // A user cannot update an email.
  password varchar [not null]
  first_name varchar [not null]
  last_name varchar [not null]
}

Table UserStatus as US {
  username varchar [pk, ref: > UT.username, not null, unique, note: "ON DELETE CASCADE and ON UPDATE CASCADE"]
  // A user can update a username.
  is_premium bool [not null]
  is_active bool [not null]
  points int [not null]
  profile_picture_id int
  mute bool [not null]
  is_private bool [not null]
  mute_notification bool [not null]
  exp int [not null]
  bio varchar
}

Table SubscriptionObject {
  soid int [pk, increment, not null, unique]
  uid int [ref: > UT.uid, not null, note: "ON DELETE CASCADE"]
  endpoints varchar [not null, unique]
  auth varchar [not null]
  p256dh varchar [not null]
}

Table RoadmapTable as RT {
  rid int [pk, increment, not null, unique]
  owner_id int [not null, ref: > UT.uid, note: "ON DELETE CASCADE"] 
  //If the owner of the roadmap is deleted, the roadmap should be deleted as well.
  creator_id int [ref: > UT.uid, not null, note: "ON DELETE SET NULL"]
  //Although the real creater of the roadmap is deleted, the roadmap should still be able to use.
  created_at datetime [not null]
  edited_at datetime 
  title varchar [not null]
  description varchar
  roadmap_deadline datetime
  is_private bool [not null]
  task_relation "int[]" [not null]
  archive_date datetime
  is_before_start_time boolean [not null]
  reminder_time int [not null]
  forks_count int [not null]
  views_count int [not null]
  stars_count int [not null]
}

Table TaskTable as TT {
  tid int [pk, increment, not null, unique]
  rid int [ref: > RT.rid, not null, note: "ON DELETE CASCADE"]
  title varchar [not null]
  description varchar
  color varchar [not null]
  shape varchar [not null]
  start_time datetime
  deadline datetime
  is_done boolean [not null]
}

Table SubTaskTable as STT {
  stid int [pk, increment, not null, unique]
  tid int [ref: > TT.tid, not null, note: "ON DELETE CASCADE"]
  title varchar [not null]
  is_done bool [not null]
}

Table TagTable as TGT {
  tagid int [pk, increment, not null, unique]
  name varchar [unique, not null, unique]
  count int [not null]
}

Table ToDo {
  DID int [pk, increment, not null, unique]
  UID int [ref: > UT.uid, not null, note: "ON DELETE CASCADE"]
  when datetime [not null]
  title varchar [not null]
  is_done boolean [not null]
}

Table NotificationTable as NT {
  nid int [pk, increment, not null, unique]
  tid int [ref: > TT.tid, not null, note: "ON DELETE CASCADE"]
  when datetime [not null]
}

Table DailyQuest as DT {
  qid int [pk, not null]
  uid int [ref: > UT.uid, not null, note: "ON DELETE CASCADE"]
  date datetime [pk, not null]
  is_done bool [not null]
}

Table UserSubscription as USS {
  creator_id int [pk, not null, ref: > UT.uid, note: "ON DELETE CASCADE"]
  subscriber_id  int [pk, not null, ref: > UT.uid, note: "ON DELETE CASCADE"]
}

Table RoadmapTag as RTG {
  tagid int [pk, not null, ref: > TGT.tagid, note: "ON DELETE Restrict"]
  rid int [pk, not null, ref: > RT.rid, note: "ON DELETE CASCADE"]
}

Table RoadmapStar {
  rid int [pk, not null, ref: > RT.rid, note: "ON DELETE CASCADE"]
  uid int [pk, not null, ref: > UT.uid, note: "ON DELETE CASCADE"]
}


```