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

  @spec gettoken(any(), any()) :: Tesla.Env.t()
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

  @spec getVehicle(binary() | Tesla.Client.t()) :: any()
  def getVehicle(client) do
    {:ok, resp} = Tesla.get(client, "/api/1/vehicles")
    resp.body
  end

  @spec getVehicle(binary() | Tesla.Client.t(), binary()) :: any()
  def getVehicle(client, id) do
    {:ok, resp} = Tesla.get(client, "/api/1/vehicles/"<> id)
    resp.body
  end

  @spec getVehicleData(binary() | Tesla.Client.t(), binary()) :: any()
  def getVehicleData(client, id) do
    {:ok, resp} = Tesla.get(client, "/api/1/vehicles/"<> id <> "/vehicle_data")
    resp.body
    # TODO: wake vehicle if unavailable
  end

  @spec getVehicleChargeState(binary() | Tesla.Client.t(), binary()) :: any()
  def getVehicleChargeState(client, id) do
    {:ok, resp} = Tesla.get(client, "/api/1/vehicles/"<> id <> "/data_request/charge_state")
    resp.body
  end

  @spec getVehicleClimateState(binary() | Tesla.Client.t(), binary()) :: any()
  def getVehicleClimateState(client, id) do
    {:ok, resp} = Tesla.get(client, "/api/1/vehicles/"<> id <> "/data_request/climate_state")
    resp.body
  end

  @spec getVehicleDriveState(binary() | Tesla.Client.t(), binary()) :: any()
  def getVehicleDriveState(client, id) do
    {:ok, resp} = Tesla.get(client, "/api/1/vehicles/"<> id <> "/data_request/drive_state")
    resp.body
  end

  @spec getVehicleGUISettings(binary() | Tesla.Client.t(), binary()) :: any()
  def getVehicleGUISettings(client, id) do
    {:ok, resp} = Tesla.get(client, "/api/1/vehicles/"<> id <> "/data_request/gui_settings")
    resp.body
  end

  @spec getVehicleState(binary() | Tesla.Client.t(), binary()) :: any()
  def getVehicleState(client, id) do
    {:ok, resp} = Tesla.get(client, "/api/1/vehicles/"<> id <> "/data_request/vehicle_state")
    resp.body
  end

  @spec getVehicleConfig(binary() | Tesla.Client.t(), binary()) :: any()
  def getVehicleConfig(client, id) do
    {:ok, resp} = Tesla.get(client, "/api/1/vehicles/"<> id <> "/data_request/vehicle_config")
    resp.body
  end

  @spec getVehicleMobile(binary() | Tesla.Client.t(), binary()) :: any()
  def getVehicleMobile(client, id) do
    {:ok, resp} = Tesla.get(client, "/api/1/vehicles/"<> id <> "/mobile_enabled")
    resp.body
  end

  @spec getVehicleNearbyChargers(binary() | Tesla.Client.t(), binary()) :: any()
  def getVehicleNearbyChargers(client, id) do
    {:ok, resp} = Tesla.get(client, "/api/1/vehicles/"<> id <> "/nearby_charging_sites")
    resp.body
  end

  @spec wakeVehicle(binary() | Tesla.Client.t(), binary()) :: any()
  def wakeVehicle(client, id) do
    {:ok, resp} = Tesla.post(client, "/api/1/vehicles/"<> id <> "/wake_up", "good morning")
    resp.body
  end

  @spec scheduleUpdate(binary() | Tesla.Client.t(), binary()) :: any()
  def scheduleUpdate(client, id) do
    {:ok, resp} = Tesla.post(client, "/api/1/vehicles/"<> id <> "/command/schedule_software_update", "yay new stuff \o/")
    resp.body
  end

  def scheduleUpdate(client, id) do
    {:ok, resp} = Tesla.post(client, "/api/1/vehicles/"<> id <> "/command/schedule_software_update", "yay new stuff \o/")
    resp.body
  end

  @spec navigationRequest(binary() | Tesla.Client.t(), binary(), any()) :: any()
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

  @spec client(binary()) :: Tesla.Client.t()
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
