class Guests < Cuba
  define do
    board = Board[1]

    on "new" do
      Board[1].reset!

      res.redirect "/"
    end

    on "events" do
      on get do

        res.headers["Content-Type"] = "text/event-stream"
        res.write("event: move\n")
        res.write("retry: 200\n")
        res.write(sprintf("id: %s\n", Time.now.to_i))
        res.write(sprintf("data: %s\n", board.last_move))
        res.write("\n\n")
      end
    end

    on "games/1" do
      on "play/:col" do |col|
        on post do
          move = Player[1].move(Integer(col))

          if move.last == :ok
            res.status = 200
            res.write JSON.dump(move)
          else
            res.status = 400
            res.write JSON.dump(move)
          end
        end
      end

      on root do
        render("player_1", title: "Player 1", grid: board.grid)
      end
    end

    on "games/2" do
      on "play/:col" do |col|
        on post do
          move = Player[2].move(Integer(col))

          if move.last == :ok
            res.status = 200
            res.write JSON.dump(move)
          else
            res.status = 400
            res.write JSON.dump(move)
          end
        end
      end

      on root do
        render("player_2", title: "Player 2", grid: board.grid)
      end
    end

    on get, root do
      render("home", title: "Home")
    end
  end
end
