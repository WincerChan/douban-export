defmodule DoubanShow.Book do
  import Tool

  @internel 15
  @url_prefix "https://book.douban.com/people"
  @douban_id Application.get_env(:douban_show, :doubanid)

  def concat_url(num) do
    "#{@url_prefix}/#{@douban_id}/collect?start=#{num * @internel}"
  end

  def date(book_item) do
    book_item
    |> Floki.find(".date")
    |> Floki.text(deep: false)
    |> String.split("\n")
    |> hd
  end

  def title(book_item) do
    main =
      book_item
      |> Floki.find("h2 > a")
      |> Floki.attribute("title")
      |> Floki.text(deep: false)

    slave =
      book_item
      |> Floki.find("h2 span")
      |> Floki.text(deep: false)

    "#{main}#{slave}"
  end

  def rating(book_item) do
    book_item
    |> Floki.find(".short-note span:nth-child(1)")
    |> Floki.attribute("class")
    |> Floki.text(deep: false)
    |> String.at(6)
    |> get_rating
  end

  def parse(m) do
    {:ok, pid} = DoubanItem.new()

    DoubanItem.put(pid, comment(m))
    DoubanItem.put(pid, rating(m))
    DoubanItem.put(pid, cover(m))
    DoubanItem.put(pid, title(m))
    DoubanItem.put(pid, tags(m))
    DoubanItem.put(pid, date(m))
    DoubanItem.put(pid, url(m))
    DoubanItem.put(pid, "book")
    DoubanItem.identify(pid)

    DoubanItem.get(pid)
    |> DoubanShow.Persist.save_record()
  end

  def fetch(page) do
    with url <- concat_url(page) do
      parse_content(url)
      |> Floki.find(".subject-item")
      |> Enum.map(&parse/1)

      IO.puts("URL: #{url} done.")
    end
  end
end
