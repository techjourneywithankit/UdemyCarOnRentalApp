trigger ContactTrigger on Contact (after insert, after update) {
    new MetadataTriggerHandler().run();
}