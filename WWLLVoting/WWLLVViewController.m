/*
Copyright (C) 2012 Matteo Manferdini. All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

* Neither the name of the author nor the names of its contributors may be used
  to endorse or promote products derived from this software without specific
  prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
		 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#import "WWLLVViewController.h"

@interface WWLLVViewController ()

@property NSInteger noVotes, yesVotes;

@end

enum {
	YesButtonTag,
	NoButtonTag
};

@implementation WWLLVViewController;

#pragma mark -
#pragma mark UIViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	[self.scrollView setContentSize:CGSizeMake(self.view.bounds.size.width * 2, self.view.bounds.size.height)];
	
	[[NSBundle mainBundle] loadNibNamed:@"VotingView" owner:self options:nil];
	[self.scrollView addSubview:self.votingView];
	
	[[NSBundle mainBundle] loadNibNamed:@"DataView" owner:self options:nil];
	[self.scrollView addSubview:self.dataView];
	CGRect dataViewFrame = self.dataView.frame;
	dataViewFrame.origin.x = self.votingView.frame.size.width;
	self.dataView.frame = dataViewFrame;
	
	self.dateLabel.text = [self formattedDate];
	[self updateLabels];
}

- (void)viewDidUnload {
	[self setScrollView:nil];
    [self setYesVotesLabel:nil];
    [self setNoVotesLabel:nil];
    [self setPercentageVotesLabel:nil];
	[self setVotingView:nil];
	[self setDataView:nil];
	[self setDateLabel:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0)
		return;
	
	self.noVotes = 0;
	self.yesVotes = 0;
	[self updateLabels];
}

#pragma mark -
#pragma mark Public

- (IBAction)reset:(id)sender {
	[[[UIAlertView alloc] initWithTitle:@"Reset Voting" message:@"Are you sure you want to reset the voting?" delegate:self cancelButtonTitle:@"Don't reset" otherButtonTitles:@"Reset", nil] show];
}

- (IBAction)vote:(UIButton *)sender {
	if (sender.tag == YesButtonTag)
		self.yesVotes++;
	else
		self.noVotes++;
	
	[self updateLabels];
}

#pragma mark -
#pragma mark Private

- (void)updateLabels {
	self.yesVotesLabel.text = [NSString stringWithFormat:@"%i", self.yesVotes];
	self.noVotesLabel.text = [NSString stringWithFormat:@"%i", self.noVotes];
	if (self.yesVotes + self.noVotes == 0)
		self.percentageVotesLabel.text = nil;
	else
		self.percentageVotesLabel.text = [NSString stringWithFormat:@"%.0f%%", (float)self.yesVotes * 100 / (float)(self.yesVotes + self.noVotes)];
	
	self.dateLabel.text = [self formattedDate];
}

- (NSString *)formattedDate {
	NSDateFormatter *dateFormatter = [NSDateFormatter new];
	dateFormatter.timeStyle = NSDateFormatterNoStyle;
	dateFormatter.dateStyle = NSDateFormatterMediumStyle;
	return [dateFormatter stringFromDate:[NSDate date]];
}

@end
