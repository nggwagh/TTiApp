//
//  HomeNavigation.swift
//  TeamTTI
//
//  Created by Mayur Deshmukh on 11/11/18.
//  Copyright © 2018 TeamTTI. All rights reserved.
//

import Foundation

extension Constant.Storyboard {
    struct Home {
        static let id = "Home"
        static let id_manager = "ManagerHome"
        static let leftSideMenuNavigationController = "LeftSideMenuNavigationController"
        static let TaskDetailSegueIdentifier = "TaskDetailSegueIdentifier"
        static let TaskSegueIdentifier = "TaskSegueIdentifier"
        static let SubmissionSegueIdentifier = "SubmissionSegueIdentifier"
        static let RegionObjectiveDetailIdentifier = "RegionObjectiveDetailIdentifier"
    }
    
    struct News {
        static let id = "News"
        static let newsDetailsSegueIdentifier = "NewsDetailsIdentifier"
    }
    
    struct Playbook {
        static let id = "Playbook"
        static let viewPlaybookIdentifier = "ViewPlaybookIdentifier"
        static let playbookDetailViewController = "PlaybookDetailViewController"
        
    }
    
    struct Survey {
        static let id = "Survey"
        static let surveyDetailsSegueIdentifier = "SurveyDetailsIdentifier"
        static let openSurveySegueIdentifier = "OpenSurveyIdentifier"

    }
    
    struct Planner {
        static let id = "Planner"
        static let PlannerViewControllerIdentifier = "PlannerViewControllerIdentifier"
    }
    
}
