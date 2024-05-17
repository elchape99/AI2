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
    ;(at MR1 mountain)
    ;(information_acquired camera fully desert)
    ;(analysis_performed MR1 camera desert fully)
    ;(data_sended MR1 desert camera fully)
    (communication_closed MR1 iceland camera fully retracted)
    at(MR1 desert)
    ;(ready_for_task MR1 desert camera fully)
    ;(data_sended MR1 mountain valley halfway)
    ;(communication_closed MR1 valley spectrometer halfway retracted)

    
    )
)

;un-comment the following line if metric is needed
;(:metric minimize (???))
)

;---------------------------------------------------------------------------------------
;;using this problem file with intermediate goal to try to debug I obtained this PLAN:

;(move mr1 home desert)
;(stabilize mr1)
;(activate_sensor mr1 camera)
;(untack mr1 gripper)
;(set_manipulator mr1 gripper retracted fully)
;(aquire_information mr1 camera desert gripper fully)
;(perform_analysis mr1 camera fully desert)

;;It seems to be ok, but if I add to the goal also the line: (data_sended MR1 desert), I obtain this plan:

;(move mr1 home desert)
;(stabilize mr1)
;(activate_sensor mr1 camera)
;(untack mr1 gripper)
;(aquire_information mr1 camera desert gripper retracted)
;(perform_analysis mr1 camera retracted desert)
;(send_data mr1 camera retracted desert)
;(set_manipulator mr1 gripper retracted fully)
;(aquire_information mr1 camera desert gripper fully)

;;So after sending data it set_manipulator and aquire_information again
