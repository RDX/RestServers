var comm = require('C4Communicator');
/*
 * GET home page.
 */

exports.index = function(req, res){
	comm.getLights(function(data){
		res.send(data);
	});
	
};
