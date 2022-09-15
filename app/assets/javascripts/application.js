const rgba2hex = (rgba) => `#${rgba.match(/^rgba?\((\d+),\s*(\d+),\s*(\d+)(?:,\s*(\d+\.{0,1}\d*))?\)$/).slice(1).map((n, i) => (i === 3 ? Math.round(parseFloat(n) * 255) : parseFloat(n)).toString(16).padStart(2, '0').replace('NaN', '')).join('')}`

$(document).ready(function () {
    $.ajaxSetup({
        headers: {
            'X-CSRF-TOKEN': $('meta[name=csrf-token]').attr('content')
        }
    });
});

$('.btn-color').click(function () {
    $('.btn-color').removeClass('color-selected-border');
    $(this).toggleClass('color-selected-border');
});

$('.btn-remove').click(function () {
    if (confirm('Are you sure you want to delete this reminder?')) {
        $.ajax({
            url: `/reminder/${ $('#reminder_id').val() }`,
            type: 'DELETE',
            success: function (result) {
                alert("Deleted successfully!");
                window.location.assign($('#show_url').val());
            },
            error: function (xhr, status, error) {
                alert(error.error);
            }
        });
    }
});

$('.btn-save').click(function () {
    $('.error').addClass('invisible');
    const title = $('#calendar_title').val();
    const description = $('#calendar_description').val();
    const reminder_date = $('#reminder_date').val();
    const reminder_time = $('#reminder_time').val();
    const color = $('.color-selected-border').css('background-color') ? rgba2hex($('.color-selected-border').css('background-color')) : '';
    let isValidate = true;
    if (!title) {
        $('#calendar_title ~ p').removeClass('invisible');
        isValidate = false;
    }
    if (!description) {
        $('#calendar_description ~ p').removeClass('invisible');
        isValidate = false;
    }
    if (!reminder_date) {
        $('#reminder_date ~ p').removeClass('invisible');
        isValidate = false;
    }
    if (!reminder_time) {
        $('#reminder_time ~ p').removeClass('invisible');
        isValidate = false;
    }
    if (!color) {
        $('.color-boxes p').removeClass('invisible');
        isValidate = false;
    }
    if (isValidate) {
        const mode = $('#mode').val();
        $.ajax({
            url: mode == 'edit' ? `/reminder/${ $('#reminder_id').val() }` : '/reminder',
            type: mode == 'edit' ? 'PATCH' : 'POST',
            data: {
                title,
                description,
                reminder_date,
                reminder_time,
                color
            },
            success: function (result) {
                alert(`${ mode == 'edit' ? "Edited" : "Added" } successfully!`);
                window.location.assign($('#show_url').val());
            },
            error: function (xhr, status, error) {
                alert(error.error);
            }
        });
    }
});
