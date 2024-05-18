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

    (has_man MR1 gripper)
    (at_pose gripper retracted) ; gripper is retracted
    (tack MR1 gripper) ; gripper is attached

    (has_sensor MR1 spectrometer) ; sensors
    (has_sensor MR1 camera)
    (has_sensor MR1 radar)
    
    (unstable MR1) 

    
    

)

(:goal (and
    ;todo: put the goal condition here
    (communication_closed MR1 mountain camera fully)
    ;(at MR1 valley)
    ;(at_pose gripper retracted)
    ;(at MR1 mountain)
    ;(information_acquired camera fully desert)
    ;(analysis_performed MR1 camera desert fully)
    ;(data_sended MR1 desert camera fully)
    ;(data_sended MR1 mountain valley halfway)
    (communication_closed MR1 valley radar halfway)

    
    )
)

;un-comment the following line if metric is needed
;(:metric minimize (???))
)

