import scala.io.Source._
import play.api.libs.json._
import play.api.libs.json.Reads._
import play.api.libs.functional.syntax._


// Run from command line with `sbt run`
object Solution {
  def main(args: Array[String]) = println("Implement me")
}

// Helper to parse JSON files
object JsonParser {

  def read(filePath: String): JsValue = {
    val jsonString = scala.io.Source.fromFile(filePath).mkString
    return Json.parse(jsonString)
  }

  // Parsing Users
  case class User(gender: String, age: Int, device: String)

  implicit val userReads: Reads[User] = (
    (JsPath \ "gender").read[String] and
    (JsPath \ "age").read[Int] and
    (JsPath \ "device").read[String]
  )(User.apply _)

  def users: Map[String,User] = (read("../data/users.json") \ "users").as[Map[String,User]]

  // Parsing Events
  case class Event(name: String, timestamp: Int, user_id: String)

  implicit val eventReads: Reads[Event] = (
    (JsPath \ "name").read[String] and
    (JsPath \ "timestamp").read[Int] and
    (JsPath \ "user_id").read[String]
  )(Event.apply _)

  def events: List[Event] = (read("../data/events.json") \ "events").as[List[Event]]

}
