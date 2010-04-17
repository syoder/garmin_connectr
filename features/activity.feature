Scenario: Load Activity
  Given I have loaded activity 30051790
  Then the name should be "MTB - Mesh RDL "
  And the device should be "Garmin Edge 500"
  And the url should be "http://connect.garmin.com/activity/30051790"
  And the activity_type should be "Mountain Biking"
  And the event_type should be "Training"
  And the timestamp should be "Wed, Apr 14, 2010 1:46 PM"
  And the time should be "00:55:15"
  And the distance should be "5.26 mi"
  And the elevation_gain should be "610 ft"
  And the calories should be "433 C"
  And the avg_temperature should be "74.4 °F"
  And the moving_time should be "00:35:39"
  And the elapsed_time should be "00:55:15"
  And the avg_speed should be "5.7 mph"
  And the avg_moving_speed should be "8.9 mph"
  And the max_speed should be "27.1 mph"
  And the avg_pace should be "10:30 min/mi"
  And the avg_moving_pace should be "06:46 min/mi"
  And the best_pace should be "02:12 min/mi"
  And the elevation_loss should be "615 ft"
  And the min_elevation should be "334 ft"
  And the max_elevation should be "886 ft"
  And the avg_hr_bpm should be "132 bpm"
  And the max_hr_bpm should be "172 bpm"
  And the avg_hr_pom should be "67 % of Max"
  And the max_hr_pom should be "87 % of Max"  
  And the avg_hr_hrzones should be "1.0 z"
  And the max_hr_hrzones should be "3.9 z"
  And the avg_bike_cadence should be "84 rpm"
  And the max_bike_cadence should be "166 rpm"
  And the avg_temperature should be "74.4 °F"
  And the min_temperature should be "73.4 °F"
  And the max_temperature should be "78.8 °F"
  And the split_count should be "3"
  
Scenario: Load Activity with Splits
  Given I have loaded activity 30051790
  Then the split_count should be "3"
  
  And the time for split 1 should be "00:08:51"
  And the time for split 2 should be "00:26:16"
  And the time for split 3 should be "00:20:07"
  
  And the moving_time for split 1 should be "00:05:42"
  And the moving_time for split 2 should be "00:16:18"
  And the moving_time for split 3 should be "00:13:39"
  
  And the distance for split 1 should be "1.55"
  And the distance for split 2 should be "1.85"
  And the distance for split 3 should be "1.87"
  
  And the elevation_gain for split 1 should be "44"
  And the elevation_gain for split 2 should be "483"
  And the elevation_gain for split 3 should be "82"
  
  And the elevation_loss for split 1 should be "368"
  And the elevation_loss for split 2 should be "0"
  And the elevation_loss for split 3 should be "247"
  
  And the avg_speed for split 1 should be "10.5"
  And the avg_speed for split 2 should be "4.2"
  And the avg_speed for split 3 should be "5.6"
  
  And the avg_moving_speed for split 1 should be "16.3"
  And the avg_moving_speed for split 2 should be "6.8"
  And the avg_moving_speed for split 3 should be "8.2"
  
  And the max_speed for split 1 should be "27.1"
  And the max_speed for split 2 should be "13.2"
  And the max_speed for split 3 should be "25.8"
  
  And the avg_hr for split 1 should be "111"
  And the avg_hr for split 2 should be "141"
  And the avg_hr for split 3 should be "131"
  
  And the max_hr for split 1 should be "135"
  And the max_hr for split 2 should be "172"
  And the max_hr for split 3 should be "166"
  
  And the avg_bike_cadence for split 1 should be "92"
  And the avg_bike_cadence for split 2 should be "82"
  And the avg_bike_cadence for split 3 should be "84"

  And the max_bike_cadence for split 1 should be "146"
  And the max_bike_cadence for split 2 should be "146"
  And the max_bike_cadence for split 3 should be "166"

  And the calories for split 1 should be "15"
  And the calories for split 2 should be "266"
  And the calories for split 3 should be "152"
  
  And the avg_temp for split 1 should be "75.6"
  And the avg_temp for split 2 should be "74.7"
  And the avg_temp for split 3 should be "73.4"

  And the time for split summary should be "00:55:15"
  And the moving_time for split summary should be "00:35:39"
  And the distance for split summary should be "5.26"
  And the elevation_gain for split summary should be "610"
  And the elevation_loss for split summary should be "615"
  And the avg_speed for split summary should be "5.7"
  And the avg_moving_speed for split summary should be "8.9"
  And the max_speed for split summary should be "27.1"
  And the avg_hr for split summary should be "132"
  And the max_hr for split summary should be "172"
  And the avg_bike_cadence for split summary should be "84"
  And the max_bike_cadence for split summary should be "166"
  And the calories for split summary should be "433"
  And the avg_temp for split summary should be "74.4"