//
//  ScheduledEventCell.m
//  Dinner and a Show
//
//  Created by Joe Blough on 6/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ScheduledEventCell.h"
#import "ScheduledEventitem.h"

@interface ScheduledEventCell ()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *reminderImage;
@property (weak, nonatomic) IBOutlet UILabel *reminderLabel;
@property (weak, nonatomic) IBOutlet UIImageView *checkinImage;
@property (weak, nonatomic) IBOutlet UILabel *checkinLabel;
@property (weak, nonatomic) IBOutlet UIImageView *followUpImage;
@property (weak, nonatomic) IBOutlet UILabel *followUpLabel;

@end

@implementation ScheduledEventCell

@synthesize dateLabel = _dateLabel;
@synthesize descriptionLabel = _descriptionLabel;
@synthesize reminderImage = _reminderImage;
@synthesize reminderLabel = _reminderLabel;
@synthesize checkinImage = _checkinImage;
@synthesize checkinLabel = _checkinLabel;
@synthesize followUpImage = _followUpImage;
@synthesize followUpLabel = _followUpLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)displayEvent:(id<ScheduledEventitem>)event dateCellFormatter:(NSDateFormatter *)dateCellFormatter
{
    self.dateLabel.text = [dateCellFormatter stringFromDate:[event eventDate]];
    self.descriptionLabel.text = [event eventDescription];
    
    // Reminder
    if ([event respondsToSelector:@selector(reminder)] &&
        (BOOL)[event performSelector:@selector(reminder)]) {
        self.reminderImage.hidden = NO;
        self.reminderLabel.hidden = NO;
    }
    else {
        self.reminderImage.hidden = YES;
        self.reminderLabel.hidden = YES;
    }

    // Checkin
    if ([event respondsToSelector:@selector(checkin)] &&
        (BOOL)[event performSelector:@selector(checkin)]) {
        self.checkinImage.hidden = NO;
        self.checkinLabel.hidden = NO;
    }
    else {
        self.checkinImage.hidden = YES;
        self.checkinLabel.hidden = YES;
    }

    // Follow-Up
    if ([event respondsToSelector:@selector(followUp)] &&
        (BOOL)[event performSelector:@selector(followUp)]) {
        self.followUpImage.hidden = NO;
        self.followUpLabel.hidden = NO;
    }
    else {
        self.followUpImage.hidden = YES;
        self.followUpLabel.hidden = YES;
    }
}

@end
