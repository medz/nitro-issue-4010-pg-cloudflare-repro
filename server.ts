import pg from "pg";

const clientClass = pg.Client.name;

export default {
  fetch() {
    return Response.json({
      ok: true,
      builder: "rolldown",
      clientClass,
      pgVersion: pg.defaults?.client_encoding ? "loaded" : "loaded",
    });
  },
};
