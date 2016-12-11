using Toybox.WatchUi as Ui;
using Log4MonkeyC as Log;
using Toybox.System as Sys;
using Toybox.Communications as Comm;

//! Handles user interactions for the widget
class WordBehaviorDelegate extends Ui.BehaviorDelegate {
	hidden var wordView;
	hidden var logger;
	
	function initialize(wordView) {
		Ui.BehaviorDelegate.initialize();
		logger = Log.getLogger("WordBehaviorDelegate");
		self.wordView = wordView;
	}
	
	function onKey(evt) {
		logger.debug("Key press: " + evt.getKey());
		if (Ui.KEY_ENTER == evt.getKey()) {	
			self.wordView.nextDefinition();			
		} else if (Ui.KEY_ESC == evt.getKey()) {
			Ui.popView(Ui.SLIDE_IMMEDIATE);
		} else if (Ui.KEY_UP == evt.getKey() || Ui.KEY_MENU == evt.getKey()) {
			menuPress();
		}

		return true;
	}
	
	//! Specifically handles the menu key press
    function onMenu() {
    	return menuPress();
	}
	
	function onBack() {
		logger.debug("On back");
		// Exit widget
		Ui.popView(Ui.SLIDE_IMMEDIATE);
		return true;
	} 
	
	hidden function menuPress() {
		Ui.pushView(new Rez.Menus.WordMenu(), new WordMenuDelegate(), Ui.SLIDE_UP);
        return true;
	}
	
	function onTap(evt) {
		logger.debug("On tap");
		self.wordView.nextDefinition();
		return true;
	}
	
	//! Handle touch screen swipe
	function onSwipe(evt) {
		var direction = evt.getDirection();
		logger.debug("Swipe direction: " + direction);
		if (direction == 3) {
			// Left
			onNextPage();
		} else if (direction == 1) {
			// Right
			onPreviousPage();
		}
				
		return true;
	}
	
	function onHold(evt) {
		logger.info("On hold");
		if (Sys.getDeviceSettings().phoneConnected) {
			self.wordView.openWordOfTheDayWebpage();
		}
	}
	
	function onKeyReleased(evt) {
		logger.info("On release " + evt.getKey());
		if (Ui.KEY_ENTER == evt.getKey()) {
			if (Sys.getDeviceSettings().phoneConnected) {
				self.wordView.openWordOfTheDayWebpage();
			}		
		}	
	}
	
	function onNextPage() {
		logger.info("On next page");
		//wordView.nextDefinition();
		return true;
	}
	
	function onPreviousPage() {
		logger.info("On previous page");
		//wordView.previousDefinition();
		return true;		
	}
}

//! Handles the menu
class WordMenuDelegate extends Ui.MenuInputDelegate {

	function initialize() {
		Ui.MenuInputDelegate.initialize();
	}
	
	function onMenuItem(item) {
		if (item == :about) {
			var aboutView = new AboutView();
			var aboutBehaviorDelegate = new AboutMenuBehaviorDelegate(aboutView);
			Ui.pushView(aboutView, aboutBehaviorDelegate, Ui.SLIDE_IMMEDIATE);
		} else if (item == :help) {
			Ui.pushView(new HelpView(), new BaseBehaviorDelegate(), Ui.SLIDE_IMMEDIATE);
		}
	}
}

class BaseBehaviorDelegate extends Ui.BehaviorDelegate {
	function initialize() {
		Ui.BehaviorDelegate.initialize();	
	}
	
	function onBack() {
		Ui.popView(Ui.SLIDE_IMMEDIATE);
		return true;
	} 
}

//! Handles interactions with the about menu
class AboutMenuBehaviorDelegate extends BaseBehaviorDelegate {
	hidden var aboutView;
	hidden const TAP_BUFFER = 10;
	
	function initialize(aboutView) {
		BaseBehaviorDelegate.initialize();
		self.aboutView = aboutView;
	}
	
	function onTap(evt) {
    	var coords = evt.getCoordinates();
		var x = coords[0];
		var y = coords[1];
		
		if (!Sys.getDeviceSettings().phoneConnected) {
			return;
		}
		
		var providerLabel = aboutView.findDrawableById("providerLogo");						
		
		// Provider tapped
		if ((x >= applyMinusBuffer(providerLabel.locX) && x <= applyPlusBuffer(providerLabel.locX) + providerLabel.width)
			&& (y >= applyMinusBuffer(providerLabel.locY) && y <= applyPlusBuffer(providerLabel.locY) + providerLabel.height)) {
			Comm.openWebPage(Ui.loadResource(Rez.Strings.providerUrl), {}, {});
		}	
		// TODO handle developer tap when implemented
		
		return true;			
	}
	
	function onNextPage() {
		Comm.openWebPage(Ui.loadResource(Rez.Strings.providerUrl), {}, {});
		return true;
	}
	
	function onPreviousPage() {
		Comm.openWebPage(Ui.loadResource(Rez.Strings.developerUrl), {}, {});
		return true;	
	}
	
	hidden function applyPlusBuffer(value) {
		return value + TAP_BUFFER;
	}
	
	hidden function applyMinusBuffer(value) {
		return value - TAP_BUFFER;
	}

}