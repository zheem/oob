class Enent_bus(object):
    def __init__(self):
        self.subscribers = {}

    def subscribe(self, event_name, callback):
        if event_name not in self.subscribers.keys():
            self.subscribers[event_name] = [callback]
        else:
            self.subscribers[event_name].append(callback)

    def publish(self, event_name, data):
        if event_name in self.subscribers.keys():
            for callback in self.subscribers[event_name]:
                callback(data)

    def unsubscribe(self, event_name, callback):
        if event_name in self.subscribers.keys():
            self.subscribers[event_name].remove(callback)
            if len(self.subscribers[event_name]) == 0:
                del self.subscribers[event_name]

bus = Enent_bus()

cyber = lambda x: print("cl1: "+x)
steam = lambda x: print("cl2: "+x)

bus.subscribe("ok", cyber)
bus.subscribe("ok", steam)
bus.subscribe("here", cyber)

bus.publish("ok", "hi #1")
bus.publish("here", "hi #2")

bus.unsubscribe("ok", cyber)