(define (problem martian_rover_scenario) (:domain mars_rover)
(:objects
    MR-1 - rover
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
    (at MR-1 home)
    (connected home desert)
    (connected home valley)
    (connected valley mountain)
    (connected mountain iceland)
    (tack MR-1 gripper) ; gripper is attached
    (has_man MR-1 gripper)
    (has_sensor MR-1 spectrometer)   
    (has_sensor MR-1 camera)
    (has_sensor MR-1 radar)
    (at_pose gripper retracted) ; gripper is retracted


)

(:goal (and
    ;todo: put the goal condition here
    (at MR-1 iceland)
    (information_acquired camera retracted)
    (analysis_performed MR1 camera)
    (data_sended MR-1)


))

;un-comment the following line if metric is needed
;(:metric minimize (???))
)
