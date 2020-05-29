

      function countChar(val) {
        var len = val.value.length;
        if (len >= 500) {
          val.value = val.value.substring(0, 500);
        } else {
          $('#charNum').text(500 - len);
        }
      };




$('document').ready(function() {
  var selector = $('#representation_text');
  if (selector.length) {
    var len = selector.val().length;
    $('#chars').text(len + " chars");
    selector.on('keyup', function(event) {
      var len = $(this).val().length;
      if (len > 125) {
        $('#chars').css("color", "red");
      } else {
        $('#chars').css("color", "green");
      }
      $('#chars').text(len + " chars");
    });

  }
});



// $('#representation_text')

//  var maxLength = 100;
//  $('#representation_text')
//  selector.keyup(function() {
//    var length = $(this).val().length;
//    length = maxLength-length;
//    $('#chars').text(length);
//  }

