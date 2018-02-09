//
//  HallIntranceNotesViewController.m
//  MADSurvey
//
//  Created by seniorcoder on 6/8/17.
//  Copyright © 2017 seniorcoder. All rights reserved.
//

#import "HallIntranceNotesViewController.h"
#import "Constants.h"
#import "DataManager.h"

@interface HallIntranceNotesViewController ()
{
    IBOutlet UITextView * notesView;
}
@end

@implementation HallIntranceNotesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    notesView.inputAccessoryView = self.keyboardAccessoryView;
    notesView.layer.cornerRadius = 8.0f;
    
    [notesView becomeFirstResponder];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    Project *project = [DataManager sharedManager].selectedProject;
    Bank *bank = project.banks[[DataManager sharedManager].currentBankIndex];
    
    if ([DataManager sharedManager].isEditing) {
        bankLabel.text = [NSString stringWithFormat:@"Bank - %@", bank.name];
        floorLabel.text = [NSString stringWithFormat:@"Floor - %@", [DataManager sharedManager].floorDescription];
    } else {
        bankLabel.text = [NSString stringWithFormat:@"Bank %d - %@", (int32_t)[DataManager sharedManager].currentBankIndex + 1, bank.name];
        floorLabel.text = [NSString stringWithFormat:@"Floor %d of %d - %@", (int32_t)[DataManager sharedManager].currentFloorNum + 1, project.numFloors, [DataManager sharedManager].floorDescription];
        carNumberLabel.text = [NSString stringWithFormat:@"Car %d of %d", (int32_t)[DataManager sharedManager].currentHallEntranceCarNum + 1, bank.numOfCar];
    }

    HallEntrance *hallEntrance = [[DataManager sharedManager] getHallEntranceForBank:bank floorDescription:[DataManager sharedManager].floorDescription hallEntranceCarNum:[DataManager sharedManager].currentHallEntranceCarNum];
    notesView.text = hallEntrance.notes ? hallEntrance.notes : @"";
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender {
    Project *project = [DataManager sharedManager].selectedProject;
    Bank *bank = project.banks[[DataManager sharedManager].currentBankIndex];
    HallEntrance *hallEntrance = [[DataManager sharedManager] getHallEntranceForBank:bank floorDescription:[DataManager sharedManager].floorDescription hallEntranceCarNum:[DataManager sharedManager].currentHallEntranceCarNum];
    
    hallEntrance.notes = notesView.text;

    [self performSegueWithIdentifier:UINavigationIDHallInstrancePhotos sender:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
