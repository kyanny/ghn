package main

import (
	"net/http"
	"io/ioutil"
	"os"
	"fmt"
	"encoding/json"
	"log"
	"runtime"
	"time"
)

type Notification struct {
	Subject struct {
		Url string
		LatestCommentUrl string `json:"latest_comment_url"`
	}
}

type Url struct {
	HtmlUrl string `json:"html_url"`
}

var token = os.Getenv("GITHUB_API_TOKEN")
var endpoint = "https://api.github.com/notifications"

func main() {
	cpus := runtime.NumCPU()
	log.Println(cpus)
	runtime.GOMAXPROCS(cpus)

	if token == "" {
		log.Fatal("token is not set")
		os.Exit(1)
	}

	req, _ := http.NewRequest("GET", endpoint, nil)
	req.Header.Set("Authorization", "token " + token)

	client := new(http.Client)
	resp, _ := client.Do(req)
	defer resp.Body.Close()

	bytes, _ := ioutil.ReadAll(resp.Body)

	data := make([]Notification, 0)
	json.Unmarshal(bytes, &data)

	ch := make(chan string)
	for i := 0; i < len(data); i++ {
		go func(url string) {
			req, _ := http.NewRequest("GET", url, nil)
			req.Header.Set("Authorization", "token " + token)

			client := new(http.Client)

			resp, _ := client.Do(req)
			defer resp.Body.Close()

			bytes, _ := ioutil.ReadAll(resp.Body)

			data := new(Url)
			json.Unmarshal(bytes, data)

			ch <- data.HtmlUrl
			fmt.Println(data.HtmlUrl)
		}(data[i].Subject.LatestCommentUrl)
	}

	for i := 0; i < len(data); i++ {
		htmlUrl := <-ch
		fmt.Println(fmt.Sprintf("open %s", htmlUrl))
		time.Sleep(time.Second)
	}
}
