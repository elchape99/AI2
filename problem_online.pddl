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
    (at MR1 home)
    (connected home desert)
    (connected home valley)
    (connected valley mountain)
    (connected mountain iceland)
    (tack MR1 gripper) ; gripper is attached
    (has_man MR1 gripper)
    (has_sensor MR1 spectrometer)   
    (has_sensor MR1 camera)
    (has_sensor MR1 radar)
    (at_pose gripper retracted) ; gripper is retracted
    (unstable MR1) 


)

(:goal (and
    ;todo: put the goal condition here
    (at MR1 desert)
    (information_acquired camera fully desert)
    (analysis_performed MR1 camera desert)
    ;(data_sended MR1 desert)
    )
)

;un-comment the following line if metric is needed
;(:metric minimize (???))
)
