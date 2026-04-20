import asyncio
from asyncua import Server


async def main():
    server = Server()
    await server.init()

    server.set_endpoint("opc.tcp://127.0.0.1:4840/demo/")
    server.set_server_name("Python OPC UA Demo")

    uri = "urn:demo:python-opcua"
    idx = await server.register_namespace(uri)

    objects = server.nodes.objects
    demo = await objects.add_object(idx, "Demo")

    teplota = await demo.add_variable(idx, "Teplota-okoli", 23.5)
    tlak = await demo.add_variable(idx, "Tlak", 1.0)
    stav = await demo.add_variable(idx, "Limit teploty", False)

    await teplota.set_writable()
    await tlak.set_writable()
    await stav.set_writable()

    async with server:
        while True:
            v = await teplota.read_value()
            print("Teplota =", v)

            if v > 30.0:
                await stav.write_value(True)
            else:
                await stav.write_value(False)

            if v >= 50:
                await teplota.write_value(23.5)
                await tlak.write_value(1.0)
            else:
                await teplota.write_value(v + 0.1)
                v = await tlak.read_value()
                await tlak.write_value(v + 0.1)

            await asyncio.sleep(1)


if __name__ == "__main__":
    asyncio.run(main())