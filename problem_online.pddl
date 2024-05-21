(define (problem martian_rover_scenario) (:domain mars_rover)
(:objects
    MR1 - rover
    home - location
    mountain - location
    desert - location
    iceland - location
    valley - location
    retracted - man_pose
    halfway - man_pose
    fully - man_pose
    gripper - manipulator
    spectrometer - spectrometer 
    camera - camera
    radar - radar
    earth - planet
    mars - planet
    
)

(:init
    ;todo: put the initial state's facts and numeric values here
    (at MR1 home) ; initial location of the rover

    (connected home desert) ; map of mars
    (connected desert home)
    (connected home valley)
    (connected valley home)
    (connected valley mountain)
    (connected mountain valley)
    (connected mountain iceland)
    (connected iceland mountain)

    (sensor_pose camera fully)
    (sensor_pose radar retracted)
    (sensor_pose spectrometer halfway)
    
    (has_man MR1 gripper)
    (at_pose gripper retracted) ; gripper is retracted
    (tack MR1 gripper) ; gripper is attached
    (ready_to_tack MR1 retracted) ; gripper is ready to
    (has_sensor MR1 spectrometer) ; sensors
    (has_sensor MR1 camera)
    (has_sensor MR1 radar)

    (home MR1 home) ; home location of the rover
    
    (at_camera camera valley) ; camera must be used at the valley
    (at_spectrometer spectrometer iceland) ; spectrometer must be used in the iceland
    (at_radar radar mountain) ; radar must be used in the mountain
    
    
    (count_0 camera)
    
    (unstable MR1) 

    
    

)

(:goal (and
    ;todo: put the goal condition here
    ;(information_acquired camera mountain)
    ;(communication_closed MR1 mountain camera fully)
    ;(at MR1 valley)
    ;(at_pose gripper retracted)
    ;(at MR1 mountain)
    ;(information_acquired camera fully desert)
    ;(analysis_performed MR1 camera desert)
    ;(analysis_performed MR1 radar desert)
    ;(data_sended MR1 camera)
    (communication_closed MR1 camera)
    (communication_closed MR1 spectrometer)
    (communication_closed MR1 radar)
    ;(data_sended MR1 radar mountain)
    ;(communication_closed MR1 valley radar halfway)

    
    )
)

;un-comment the following line if metric is needed
;(:metric minimize (???))
)

