using Toybox.WatchUi as Ui;
using Toybox.Communications as Comm;
using Toybox.System as Sys;
using Log4MonkeyC as Log;

// View that displays how-to information
class HelpView extends Ui.View {
	hidden var logger;
	
	function initialize() {
		Ui.View.initialize();
	}
	
    //! Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.HelpLayout(dc));
    }

    //! Restore the state of the app and prepare the view to be shown
    function onShow() {    	
		// Nothing
    }

    //! Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
        new Rez.Drawables.menuSeparator().draw(dc);
    }

    //! Called when this View is removed from the screen. Save the
    //! state of your app here.
    function onHide() {
    	// Nothing yet
    }
}