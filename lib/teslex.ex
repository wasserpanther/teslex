defmodule Teslex do
  @moduledoc """
  Documentation for Teslex.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Teslex.hello()
      :world

  """
  use Tesla

  def gettoken(email, pass) do
    clientId = "81527cff06843c8634fdc09e8ac0abefb46ac849f38fe1e431c2ef2106796384"
    clientSecret = "c7257eb71a564034f9419ee651c7d0e5f7aa6bfbd18bafb5c5c033b093bb2fa3"
    body = %{
      grant_type: "password",
      client_id: clientId,
      client_secret: clientSecret,
      email: email,
      password: pass
    }
    encBody = Jason.encode(body)
    # client = Tesla.client([], Tesla.Adapter.Hackney)
    {:ok, response} = Tesla.post("https://owner-api.teslamotors.com/oauth/token?grant_type=password", body, headers: [{"content-type", "application/json"}])
    # {:ok, response} = Tesla.post("http://httpbin.org/post", "data", headers: [{"content-type", "application/json"}])
    response
  end

  def getVehicle(client) do
    {:ok, resp} = Tesla.get(client, "/api/1/vehicles")
    resp.body
  end

  def getVehicle(client, id) do
    {:ok, resp} = Tesla.get(client, "/api/1/vehicles/"<> id)
    resp.body
  end

  def getVehicleData(client, id) do
    {:ok, resp} = Tesla.get(client, "/api/1/vehicles/"<> id <> "/vehicle_data")
    resp.body
    # TODO: wake vehicle if unavailable
  end

  def getVehicleChargeState(client, id) do
    {:ok, resp} = Tesla.get(client, "/api/1/vehicles/"<> id <> "/data_request/charge_state")
    resp.body
  end

  def getVehicleClimateState(client, id) do
    {:ok, resp} = Tesla.get(client, "/api/1/vehicles/"<> id <> "/data_request/climate_state")
    resp.body
  end

  def getVehicleDriveState(client, id) do
    {:ok, resp} = Tesla.get(client, "/api/1/vehicles/"<> id <> "/data_request/drive_state")
    resp.body
  end

  def getVehicleGUISettings(client, id) do
    {:ok, resp} = Tesla.get(client, "/api/1/vehicles/"<> id <> "/data_request/gui_settings")
    resp.body
  end

  def getVehicleState(client, id) do
    {:ok, resp} = Tesla.get(client, "/api/1/vehicles/"<> id <> "/data_request/vehicle_state")
    resp.body
  end

  def getVehicleConfig(client, id) do
    {:ok, resp} = Tesla.get(client, "/api/1/vehicles/"<> id <> "/data_request/vehicle_config")
    resp.body
  end

  def getVehicleMobile(client, id) do
    {:ok, resp} = Tesla.get(client, "/api/1/vehicles/"<> id <> "/mobile_enabled")
    resp.body
  end

  def getVehicleNearbyChargers(client, id) do
    {:ok, resp} = Tesla.get(client, "/api/1/vehicles/"<> id <> "/nearby_charging_sites")
    resp.body
  end

  def wakeVehicle(client, id) do
    {:ok, resp} = Tesla.post(client, "/api/1/vehicles/"<> id <> "/wake_up", "good morning")
    resp.body
  end

  def scheduleUpdate(client, id) do
    {:ok, resp} = Tesla.post(client, "/api/1/vehicles/"<> id <> "/command/schedule_software_update", "yay new stuff \o/")
    resp.body
  end

  def scheduleUpdate(client, id) do
    {:ok, resp} = Tesla.post(client, "/api/1/vehicles/"<> id <> "/command/schedule_software_update", "yay new stuff \o/")
    resp.body
  end

  def navigationRequest(client, id, dest) do
    reqBody = %{
        "type" => "share_ext_content_raw",
        "value" => %{
          "android.intent.extra.TEXT": dest
        },
        "locale" => "en-US",
        "timestamp_ms" => "1539465730"
    }
    {:ok, resp} = Tesla.post(client, "/api/1/vehicles/"<> id <> "/command/navigation_request", reqBody)
    resp.body
  end

  def client(token) do
    middleware = [
      {Tesla.Middleware.BaseUrl, "https://owner-api.teslamotors.com"},
      Tesla.Middleware.JSON,
      Tesla.Middleware.DecodeJson,
      {Tesla.Middleware.Headers, [
        {"user-agent", "Teslex - Elixir Tesla Client"},
        {"content-type", "application/json"},
        {"Authorization", "Bearer " <> token}
      ]}
    ]
    Tesla.client(middleware)
  end
end
