document.addEventListener 'turbolinks:load', ->
  App.room = App.cable.subscriptions.create { channel: "RoomChannel", room_id: $('#messages').data('room_id') },
    connected: ->

    disconnected: ->

    received: (data) ->
      # view/rooms/showに埋め込んであるユーザ情報と、dataとして渡された書き込みをしたユーザ情報を取得
      read_user_id = $('#read_user_id').data('read_user_id')
      write_user_id = data['write_user_id']

      # 書き込みが自分か、相手かで表示するパーシャルを変更させる
      if read_user_id == write_user_id
        $('#messages').append data['write_message']        
      else
        $('#messages').append data['read_message']

    speak: (message)->
      @perform 'speak', message: message

  $(document).on 'keypress', '[data-behavior~=room_speaker]', (event) ->
    if event.keyCode is 13 # return = send
      App.room.speak event.target.value
      event.target.value = ''
      event.preventDefault()
      