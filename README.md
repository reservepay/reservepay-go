# reservepay-go

Typed Go clients to allow usage of the Reservepay APIs - [Merchant](https://developer.reservepay.com/api/merchants), [SDK](https://developer.reservepay.com/api/sdk)
, and [Terminal](https://developer.reservepay.com/api/terminals).

The clients (found in `merchant/`, `sdk/` and `terminal/`) were generated using the [WebFunction CLI tool](https://github.com/webfunction-protocol/webfunction-cli).

## Usage

```
go get github.com/reservepay/reservepay-go
```

Each API is its own package (`merchant`, `sdk`, `terminal`). Each has a `NewClient` function which takes a `webfunction.Options` and returns a fully configured client, ready to access the associated API.

```go
package main

import (
	"fmt"
	"log"

	webfunction "github.com/webfunction-protocol/webfunction-go"

	"github.com/reservepay/reservepay-go/merchant"
)

func main() {
	client, err := merchant.NewClient(webfunction.Options{
		BearerAuth: "MY_API_KEY",
	})
	if err != nil {
		log.Fatal(err)
	}

	versions, err := client.AvailableApiVersions()
	if err != nil {
		log.Fatal(err)
	}

	fmt.Println(versions)
}
```

## Regenerating the clients

`./refresh_clients.sh` regenerates all three clients from the live APIs. It needs the `wfn` tool (set `WFN_PATH` if it is not in your `PATH`).
